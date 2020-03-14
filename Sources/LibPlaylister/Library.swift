//
//  Library.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation

public protocol Library {
    associatedtype PlaylistType: Playlist
    var playlists: [PlaylistType] { get }
    
    var artists: [Artist] { get }
    var items: [PlaylistItem] { get }
    
    func findPlaylist(named: String) -> PlaylistType?
}

extension Library {
    public func findPlaylist(named: String) -> PlaylistType? {
        playlists.compactMap { $0.findPlaylist(named: named) }.first
    }
}
