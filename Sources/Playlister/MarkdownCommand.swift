import SwiftCLI
import iTunesLibrary

class MarkdownCommand: Command {
    let name = "md"
    let shortDescription = "Generate Markdown files of playlists."
    
    func execute() throws {
        // TODO: Implement
    }
}

fileprivate extension String{
    var markdownSafe: String{
        return self.replacingOccurrences(of: "*", with: "\\*").replacingOccurrences(of: "[", with: "\\[").replacingOccurrences(of: "]", with: "\\]")
    }
}

fileprivate extension Playlist {
    func asMarkdown() -> String? {
        if isParent {
            return nil
        }
        let body = origin.items.map({ (item) -> String in
            let title = item.title.markdownSafe
            let artist = item.artist?.name
            let album: String? = (item.album.title?.isEmpty ?? true) ? nil : item.album.title
            let rating = printedRating(item.isRatingComputed ? 0 : item.rating)
            if let artist = artist {
                guard let alb = album else {
                    return "**\(title)** - \(artist.markdownSafe) (\(rating))"
                }
                return "**\(title)** - \(artist.markdownSafe) on *\(alb.markdownSafe)* (\(rating))"
            }
            guard let alb = album else {
                return "**\(title)** - Unknown Artist (\(rating))"
            }
            return "**\(title)** - Unknown Artist on *\(alb.markdownSafe)* (\(rating))"
        }).joined(separator: "\n\n")
        return "# \(name)\n\n\(body)\n"
    }
}
