//
//  Markdown.swift
//  ArgumentParser
//
//  Created by Grey Patterson on 3/14/20.
//

import LibPlaylister
import ArgumentParser

struct Markdown: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "md", abstract: "Generate a Markdown file of a playlist")
    
    @Argument() var playlistName: String
    
    @Flag() var includeRatings: Bool
    @Flag() var includeLinks: Bool
    
    func run() throws {
        let library = try MusicLibrary()
        guard let list = library.findPlaylist else {
            
        }
    }
}
