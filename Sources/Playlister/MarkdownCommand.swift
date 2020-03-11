import SwiftCLI
import Foundation
import Files
import SQLite
import LibPlaylister

class MarkdownCommand: Command {
    let name = "md"
    let shortDescription: String = "Generate a Markdown file of a playlist"
    
    @Param var playlistName: String?
    
    @Flag("-r", "--ratings", description: "Include star ratings") var includeRatings: Bool
    @Flag("-l", "--links", description: "Include links") var includeLinks: Bool
    
    @Key("-o", "--output", description: "Output directory; defaults to current directory") var outputPath: String?
    
    @Key("-n", "--name", description: "Output file name; defaults to the name of the selected playlist") var outputName: String?
    
    func execute() throws {
        let library = try _Library()
        let listName: String
        if playlistName == nil {
            for playlist in library.playlists{
                printList(playlist, depth: 0)
            }
            listName = Input.readLine(prompt: "Which playlist?")
        } else {
            listName = playlistName!
        }
        
        guard let list = library.findPlaylist(named: listName) else {
            stderr <<< "Playlist not found."
            return
        }
        
        var db: Connection? = nil
        if includeLinks {
            let workDir = try Folder.home.createSubfolderIfNeeded(at: ".playlister")
            guard let dbFile = try? workDir.file(at: "links.sqlite3") else {
                stderr <<< "Database not initialized. Run `playlister db init` first."
                return
            }
            db = try Connection(dbFile.path)
        }
        
        let folder: Folder
        if let outPath = outputPath {
            folder = try Folder(path: outPath)
        } else {
            folder = .current
        }
        let file = try folder.createFile(named: (outputName ?? listName) + ".md")
        
        try file.write(list.asMarkdown(includeRating: includeRatings, linkDatabase: db) ?? "Unable to parse")
    }
    
    
    func printList(_ list: _Playlist, depth: Int){
        let result = "\(String(repeating: " ", count: depth)) \(list.name)"
        print(result)
        for playlist in list.children {
            printList(playlist, depth: depth + 1)
        }
    }
}

internal extension _Playlist {
    /// Convert a playlist to markdown
    /// - Parameters:
    ///   - includeRating: whether or not to include star ratings
    ///   - linkDatabase: database to load/store links in; if nil, will not include links
    func asMarkdown(includeRating: Bool, linkDatabase: Connection? = nil) throws -> String? {
        if isParent {
            return nil
        }
        let body = try origin.items.map({ (item) -> String in
            let title = item.title.markdownSafe
            let artist = item.artist?.name
            let album: String? = (item.album.title?.isEmpty ?? true) ? nil : item.album.title
            var result = "**\(title)** - \(artist?.markdownSafe ?? "Unknown artist")"
            if let album = album {
                result = result + " on *\(album.markdownSafe)*"
            }
            if (includeRating) {
                result = result + " (\(printedRating(item.isRatingComputed ? 0 : item.rating)))"
            }
            if let db = linkDatabase {
                let table = Table("links")
                let id = Expression<Int64>("id")
                let link = Expression<String?>("link")
                let row = try db.prepare(table.filter(id == item.persistentID.int64Value).limit(1)).first(where: { (_) -> Bool in
                    true
                })
                let url: String?
                if row == nil {
                    let newLink = Input.readLine(prompt: "What link would you like to use for \(result)? (Leave blank for no link)", secure: false)
                    url = newLink == "" ? nil : newLink
                    let insert = table.insert(id <- item.persistentID.int64Value, link <- url)
                    try db.run(insert)
                } else {
                    url = row![link]
                }
                if let url = url {
                    result = "[\(result)](\(url))"
                }
            }
            return result
        }).joined(separator: "\n\n")
        return "# \(name)\n\n\(body)\n"
    }
}
