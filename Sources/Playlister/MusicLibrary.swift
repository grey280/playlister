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
    var parentID: Int?
    var children: [MusicPlaylist] = []
    
    var id: Int{
        origin.persistentID.intValue
    }
    
    var name: String {
        origin.name
    }
    
    var items: [PlaylistItem]
    
    fileprivate let origin: ITLibPlaylist
    
    init(itunes: ITLibPlaylist){
        origin = itunes
        items = itunes.items.map { MusicPlaylistItem(itunes: $0) }
    }
}

class MusicPlaylistItem: PlaylistItem {
    var id: Int
    
    var rating: Int?
    
    var artist: Artist?
    
    var title: String?
    
    var album: Album?
    
    init(itunes: ITLibMediaItem){
        id = itunes.persistentID.intValue
        rating = itunes.isRatingComputed ? 0 : itunes.rating
        
    }
}

class MusicArtist: Artist {
    var id: Int
    
    var name: String?
    
    init(itunes: ITLibArtist){
        id = itunes.persistentID.intValue
        name = itunes.name
    }
}

class MusicAlbum: Album {
    var id: Int
    
    var name: String?
    
    init(itunes: ITLibAlbum){
        id = itunes.persistentID.intValue
        name = itunes.title
    }
}
