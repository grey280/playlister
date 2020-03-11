//
//  Playlist.swift
//  Playlister
//
//  Created by Grey Patterson on 2/15/20.
//

import Foundation
import iTunesLibrary

class _Playlist: Identifiable {
    typealias ID = NSNumber
    
    internal let origin: ITLibPlaylist
    var children: [_Playlist] = []
    var id: ID{
        origin.persistentID
    }
    
    var parentID: _Playlist.ID?
    
    var name: String{
        origin.name
    }
    
    var isParent: Bool{
        children.count > 0
    }
    
    init(_ from: ITLibPlaylist){
        origin = from
    }
    
    func findParent(_ of: _Playlist.ID) -> _Playlist?{
        if (id == of){
            return self
        }
        return children.compactMap({ $0.findParent(of)}).first
    }
    
    func findParent(_ of: ITLibPlaylist) -> _Playlist? {
        findParent(of.persistentID)
    }
    
    func findPlaylist(named: String) -> _Playlist? {
        if (named == name){
            return self
        }
        return children.compactMap { $0.findPlaylist(named: named) }.first
    }
}
