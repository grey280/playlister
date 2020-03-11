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
}
