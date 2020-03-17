//
//  List.swift
//  ArgumentParser
//
//  Created by Grey Patterson on 3/11/20.
//

import LibPlaylister
import ArgumentParser

struct List: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "list", abstract: "List all playlists")
    
    @Flag(name: .shortAndLong, help: ArgumentHelp("Print in tree format")) var human: Bool
    
    func run() throws {
        #if os(macOS)
        let library = try MusicLibrary()
        for playlist in library.playlists {
            printList(playlist, depth: 0, increasing: human)
        }
        #else
        throw RuntimeError(description: "Unsupported operating system!")
        #endif
    }
    
    #if os(macOS)
    func printList(_ list: MusicPlaylist, depth: Int, increasing: Bool){
        let result = "\(String(repeating: " ", count: depth)) \(list.name)"
        print(result)
        let newDepth = increasing ? depth + 1 : depth
        for playlist in list.children {
            printList(playlist, depth: newDepth, increasing: increasing)
        }
    }
    #endif
}
