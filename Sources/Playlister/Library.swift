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
        
        var queue = library.allPlaylists.filter { (playlist) -> Bool in
            !playlist.isMaster && playlist.isVisible && playlist.distinguishedKind == .kindNone
        }
        while (queue.count > 0){
            let playlist = queue.remove(at: 0)
            if let parentID = playlist.parentID{
                if let parent = playlists.compactMap({$0.findParent(parentID)}).first{
                    parent.children.append(Playlist(playlist))
                } else {
                    queue.append(playlist)
                }
            } else {
                playlists.append(Playlist(playlist))
            }
        }
    }
    
    func findPlaylist(named: String) -> Playlist? {
        playlists.compactMap { $0.findPlaylist(named: named) }.first
    }
    
    var artists: [ITLibArtist]{
        library.allMediaItems.compactMap { $0.artist }
    }
    var songs: [ITLibMediaItem]{
        library.allMediaItems.filter { $0.mediaKind == .kindSong }
    }
}
