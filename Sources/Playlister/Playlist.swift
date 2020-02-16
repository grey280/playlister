//
//  Playlist.swift
//  Playlister
//
//  Created by Grey Patterson on 2/15/20.
//

import Foundation
import iTunesLibrary

struct Playlist: Identifiable {
    typealias ID = NSNumber
    
    private let origin: ITLibPlaylist
    var children: [Playlist] = []
    var id: ID{
        origin.persistentID
    }
    
    var parentID: Playlist.ID?
    
    var name: String{
        origin.name
    }
    
    var isParent: Bool{
        children.count > 0
    }
    
    init(_ from: ITLibPlaylist){
        origin = from
    }
    
    func findParent(_ of: Playlist.ID) -> Playlist?{
        if (id == of){
            return self
        }
        return children.compactMap({ $0.findParent(of)}).first
    }
    
    func findParent(_ of: ITLibPlaylist) -> Playlist? {
        findParent(of.persistentID)
    }
}
