//
//  Playlist+Helpers.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation

public extension Playlist {
    var isParent: Bool{
        children.count > 0
    }
    
    func findPlaylist(_ id: Self.ID) -> Self?{
        if (self.id == id){
            return self
        }
        return children.compactMap({ $0.findPlaylist(id)}).first
    }
    
    func findPlaylist(named: String) -> Self? {
        if (named == name){
            return self
        }
        return children.compactMap { $0.findPlaylist(named: named) }.first
    }
    
    /// Convert the playlist to Markdown
    /// - Parameters:
    ///   - ratingFormatter: `RatingFormatter` to use. If nil, does not print ratings.
    ///   - linkStore: `LinkStore` to use. If nil, does not include links.
    func asMarkdown(ratingFormatter: RatingFormatter? = nil, usingLinkStore linkStore: LinkStore? = nil) -> String? {
        if isParent {
            return nil
        }
        let body = items.map { (item) -> String in
            item.asMarkdown(ratingFormatter: ratingFormatter, usingLinkStore: linkStore)
        }.joined(separator: "\n\n")
        return "# \(name.markdownSafe)\n\n\(body)\n"
    }
}

extension PlaylistItem {
    /// Convert the item to Markdown
    /// - Parameters:
    ///   - ratingFormatter: `RatingFormatter` to use. If nil, does not print ratings.
    ///   - linkStore: `LinkStore` to use. If nil, does not include links.
    func asMarkdown(ratingFormatter: RatingFormatter? = nil, usingLinkStore linkStore: LinkStore? = nil) -> String {
        let artistName = artist?.name?.markdownSafe
        
        var result = "**\(title?.markdownSafe ?? "(Untitled item)")** - \(artistName ?? "Unknown artist")"
        if let albumTitle = album?.name?.markdownSafe {
            result = result + " on *\(albumTitle)*"
        }
        if let rateFormat = ratingFormatter {
            result = result + " (\(rateFormat.format(rating ?? 0)))"
        }
        if let store = linkStore {
            if let url = try? store.link(for: self) {
                result = "[\(result)](\(url.absoluteString))"
            }
        }
        return result
    }
}
