//
//  ListCommand.swift
//  Playlister
//
//  Created by Grey Patterson on 2/15/20.
//

import SwiftCLI

class ListCommand: Command {
    let name = "ls"
    let shortDescription = "List all playlists"
    
    @Flag("-h", "--human", "Print in a human-readable, tree format") var human: Bool
    
    func execute() throws {
        let library = try Library()
        for playlist in library.playlists {
            printList(playlist, depth: 0, increasing: human)
        }
    }
    
    func printList(_ list: Playlist, depth: Int, increasing: Bool){
        let result = "\(String(repeating: " ", count: depth)) \(list.name)"
        print(result)
        let newDepth = increasing ? depth + 1 : depth
        for playlist in list.children {
            printList(playlist, depth: newDepth, increasing: increasing)
        }
    }
    
}
