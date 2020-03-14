import SwiftCLI
import Foundation
import Files
import SQLite
import LibPlaylister


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
