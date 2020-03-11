//
//  PlaylistItem.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

protocol PlaylistItem: Identifiable {
    var rating: Double? { get }
}


/*
 
 item.persistentID.int64Value
 item.rating
 item.isRatingComputed
 item.album.title
 item.artist
 item.title
 
 */
