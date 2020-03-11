//
//  MusicLibrary.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation
import iTunesLibrary

class MusicLibrary: Library {
    var playlists: [MusicPlaylist]
    
    typealias PlaylistType = MusicPlaylist
    
    private let library: ITLibrary
    
    init() throws {
        library = try ITLibrary(apiVersion: "1.0")
        playlists = []
    }
}

final class MusicPlaylist: Playlist{
    var children: [MusicPlaylist]
    
    var parentID: ObjectIdentifier?
    
    var name: String
    
    var items: [PlaylistItem]
    
    fileprivate let origin: ITLibPlaylist
    
    init(itunes: ITLibPlaylist){
        origin = itunes
    }
}
