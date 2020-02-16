//
//  Library.swift
//  Playlister
//
//  Created by Grey Patterson on 2/15/20.
//

import Foundation
import iTunesLibrary

struct Library {
    var playlists: [Playlist]
    private let library: ITLibrary
    
    init() throws {
        library = try ITLibrary(apiVersion: "1.0")
        playlists = []
    }
}
