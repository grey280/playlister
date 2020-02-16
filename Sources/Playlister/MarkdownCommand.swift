import SwiftCLI
import Foundation
import Files
import SQLite

class MarkdownCommand: Command {
    let name = "md"
    let shortDescription: String = "Generate a Markdown file of a playlist"
    
    @Key("-i", "--input", "--playlist", description: "Name of the playlist to output") var playlistName: String?
    
    @Flag("-r", "--ratings", description: "Include star ratings") var includeRatings: Bool
    @Flag("-l", "--links", description: "Include links") var includeLinks: Bool
    
    @Key("-o", "--output", description: "Output directory; defaults to current directory") var outputPath: String?
    
    @Key("-n", "--name", description: "Output file name; defaults to the name of the selected playlist") var outputName: String?
    
    func execute() throws {
        let library = try Library()
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
        
        let folder: Folder
        if let outPath = outputPath {
            folder = try Folder(path: outPath)
        } else {
            folder = .current
        }
        let file = try folder.createFile(named: (outputName ?? listName) + ".md")
        try file.write(list.asMarkdown(includeRating: includeRatings) ?? "Unable to parse")
    }
    
    
    func printList(_ list: Playlist, depth: Int){
        let result = "\(String(repeating: " ", count: depth)) \(list.name)"
        print(result)
        for playlist in list.children {
            printList(playlist, depth: depth + 1)
        }
    }
}

/*
class MarkdownCommand: Command {
    let name = "md"
    let shortDescription = "Generate Markdown files of playlists."
    
    // Base output path to use when generating
    @Param var path: String
    
    @Flag("-r", "--rating", description: "Include star ratings in output") var rating: Bool
    
    @Key("-m", "--message", description: "Message to use when committing to Git repository.") var gitMessage: String?
    
    func execute() throws {
        let library = try Library()
        let filemanager = FileManager.default
//        let inp = PipeStream()
//        let gitInit = Task(executable: "git", arguments: ["init"], directory: path, stdout: stdout, stderr: stderr, stdin: inp)
//        gitInit.runSync()
//        let gitClear = Task(executable: "git", arguments: ["rm", "-rf", "."], directory: path, stdout: stdout, stderr: stderr, stdin: inp)
//        gitClear.runSync()
//        let gitClean = Task(executable: "git", arguments: ["clean", "-fxd"], directory: path, stdout: stdout, stderr: stderr, stdin: inp)
//        gitClean.runSync()
        
        for playlist in library.playlists {
            playlist.printPlaylist(in: path, with: filemanager)
        }
        
//        let gitAdd = Task(executable: "git", arguments: ["add", "."], directory: path, stdout: stdout, stderr: stderr, stdin: inp)
//        gitAdd.runSync()
//        let gitCommit = Task(executable: "git", arguments: ["commit", "-m", gitMessage ?? "Automated update"], directory: path, stdout: stdout, stderr: stderr, stdin: inp)
//        gitCommit.runSync()
//        let gitPush = Task(executable: "git", arguments: ["push"], directory: path, stdout: stdout, stderr: stderr, stdin: inp)
//        gitPush.runSync()
    }
}
*/
fileprivate extension String{
    var markdownSafe: String{
        return self.replacingOccurrences(of: "*", with: "\\*").replacingOccurrences(of: "[", with: "\\[").replacingOccurrences(of: "]", with: "\\]")
    }
}

fileprivate extension Playlist {
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
                result = result + "(\(printedRating(item.isRatingComputed ? 0 : item.rating)))"
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
                    let newLink = Input.readLine(prompt: "What link would you like to use for \(result)? (Enter 'x' for no link", secure: false)
                    url = newLink == "x" ? nil : newLink
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
    /*
    func printPlaylist(in path: String, with filemanager: FileManager, includeRating: Bool = false){
        if isParent{
            // create directory and recurse
            let newPath = "\(path)/\(name)"
            if (!filemanager.fileExists(atPath: newPath)){
                do {
                    try filemanager.createDirectory(atPath: newPath, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    FileHandle.standardError.write("Error: failed to create directory \(newPath)".data(using: .utf8)!)
                    exit(1)
                }
            }
            for child in children{
                child.printPlaylist(in: newPath, with: filemanager)
            }
        } else {
            // print the playlist!
            let newFileName = "\(path)/\(name).md"
            if (filemanager.fileExists(atPath: newFileName)){
                print("Removing file \(newFileName) for overwriting")
                do{
                    try filemanager.removeItem(atPath: newFileName)
                }catch let error{
                    FileHandle.standardError.write("Error: failed to remove file \(newFileName)".data(using: .utf8)!);
                    FileHandle.standardError.write(error.localizedDescription.data(using: .utf8)!)
                    exit(1)
                }
            }
            // build the file contents
            guard let body = asMarkdown(includeRating: includeRating) else {
                FileHandle.standardError.write("Error: failed to build playlist descriptor \(newFileName)".data(using: .utf8)!);
                exit(1)
            }
            //   write to the file
            guard filemanager.createFile(atPath: newFileName, contents: body.data(using: .utf8)!, attributes: nil) else{
                FileHandle.standardError.write("Error: failed to write file \(newFileName)".data(using: .utf8)!);
                exit(1)
            }
        }
    }
}
*/
