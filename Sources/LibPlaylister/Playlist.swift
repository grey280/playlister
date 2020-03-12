//
//  Playlist.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

public protocol Playlist: Identifiable {
    var children: [Self] { get }
    
    var parentID: Self.ID? { get }
    
    var name: String { get }
    
    var items: [PlaylistItem] { get }
}

public protocol PlaylistItem {
    var id: Int { get }
    /// On the scale 0-100
    var rating: Int? { get }
    
    var artist: Artist? { get }
    
    var title: String? { get }
    
    var album: Album? { get }
    
    var playCount: Int { get }
}

public protocol Artist {
    var id: Int { get }
    var name: String? { get }
}

public protocol Album {
    var id: Int { get }
    var name: String? { get }
}
