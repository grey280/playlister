//
//  Playlist+Helpers.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation

public extension Playlist {
    var isParent: Bool{
        children.count > 0
    }
    
    func findParent(_ of: Self.ID) -> Self?{
        if (id == of){
            return self
        }
        return children.compactMap({ $0.findParent(of)}).first
    }
    
    func findPlaylist(named: String) -> Self? {
        if (named == name){
            return self
        }
        return children.compactMap { $0.findPlaylist(named: named) }.first
    }
}
