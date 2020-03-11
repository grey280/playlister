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
    
    func findParent(_ of: Self.ID) -> Self?{
        if (id == of){
            return self
        }
        return children.compactMap({ $0.findParent(of)}).first
    }
    
    func findPlaylist(named: String) -> Self? {
        if (named == name){
            return self
        }
        return children.compactMap { $0.findPlaylist(named: named) }.first
    }
    
    func asMarkdown(includeRatings: Bool = false, usingLinkStore linkStore: LinkStore? = nil) -> String? {
        if isParent {
            return nil
        }
        let body = items.map { (item) -> String in
            item.asMarkdown(includeRatings: includeRatings, usingLinkStore: linkStore)
        }.joined(separator: "\n\n")
        return "# \(name.markdownSafe)\n\n\(body)\n"
    }
}

extension PlaylistItem {
    func asMarkdown(includeRatings: Bool, usingLinkStore linkStore: LinkStore?) -> String {
        let artistName = artist?.name?.markdownSafe
        
        var result = "**\(title?.markdownSafe ?? "(Untitled item)")** - \(artistName ?? "Unknown artist")"
        if let albumTitle = album?.name?.markdownSafe {
            result = result + " on *\(albumTitle)"
        }
        if (includeRatings){
            result = result + "" // TODO: Implement
        }
        if let store = linkStore {
            if let url = store.link(for: self) {
                result = "(\(result))[\(url.absoluteString)]"
            }
        }
        return result
    }
}