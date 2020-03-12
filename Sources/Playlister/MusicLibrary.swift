//
//  MusicLibrary.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation
import iTunesLibrary
import LibPlaylister

class MusicLibrary: Library {
    var artists: [Artist] {
        library.allMediaItems.compactMap { $0.artist != nil ? MusicArtist(itunes: $0.artist!) : nil }
    }
    
    var items: [PlaylistItem] {
        library.allMediaItems.compactMap { MusicPlaylistItem(itunes: $0) }
    }
    
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
    var id: Int {
        origin.persistentID.intValue
    }
    
    var rating: Int? {
        origin.isRatingComputed ? 0 : origin.rating
    }
    
    var artist: Artist?{
        if let art = origin.artist {
            return MusicArtist(itunes: art)
        }
        return nil
    }
    
    var title: String? {
        origin.title
    }
    
    var album: Album? {
        MusicAlbum(itunes: origin.album)
    }
    
    var playCount: Int {
        origin.playCount
    }
    
    fileprivate let origin: ITLibMediaItem
    
    init(itunes: ITLibMediaItem){
        origin = itunes
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
