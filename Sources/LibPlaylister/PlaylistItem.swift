//
//  PlaylistItem.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

public protocol PlaylistItem {
    var id: Int { get }
    /// On the scale 0-100
    var rating: Int? { get }
    
    var artist: Artist? { get }
}


/*
 
 item.persistentID.int64Value // in `Identifiable`
 item.album.title
 item.artist
 item.title
 
 */
