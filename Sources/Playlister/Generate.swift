//
//  Generate.swift
//  Playlister
//
//  Created by Grey Patterson on 3/14/20.
//

import LibPlaylister
import ArgumentParser
import ShellOut
import Files

struct Generate: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "generate", abstract: "Generate all playlists as markdown.", discussion: "Creates a full hierarchy of all your (normal, so excluding things like Purchased) playlists, as markdown files.\nAll generation happens in a ./playlists directory.\nAfter generation, will optionally attempt to add, commit, and push changes to the ./playlists directory as a git repository.")
    
    @Flag(name: [.long, .customShort("r")]) var includeRatings: Bool
    @Flag(name: [.long, .customShort("l")], help: "Non-interactively include links. To fill the links database, use the 'md' command.") var includeLinks: Bool
    @Flag(name: [.long, .customShort("g")]) var git: Bool
    
    func run() throws {
        let library = try MusicLibrary()
        let rootFolder = try Folder.current.createSubfolderIfNeeded(at: "playlists")
        if (git){
            try shellOut(to: ["git", "init"], at: rootFolder.path)
            try shellOut(to: ["git", "fetch"], at: rootFolder.path)
            try shellOut(to: ["git", "pull"], at: rootFolder.path)
            try shellOut(to: ["git", "rm", "-rf", "."], at: rootFolder.path)
            try shellOut(to: ["git", "clean", "-fxd"], at: rootFolder.path)
        }
       
    }
}
