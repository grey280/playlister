//
//  PlaylistItem.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

public protocol PlaylistItem: Identifiable {
    /// On the scale 0-100
    var rating: Int? { get }
    
}


/*
 
 item.persistentID.int64Value // in `Identifiable`
 item.album.title
 item.artist
 item.title
 
 */
