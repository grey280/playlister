//
//  Markdown.swift
//  ArgumentParser
//
//  Created by Grey Patterson on 3/14/20.
//

import LibPlaylister
import ArgumentParser
import Files

struct Markdown: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "md", abstract: "Generate a Markdown file of a playlist")
    
    @Argument() var playlistName: String
    
    @Flag() var includeRatings: Bool
    @Flag() var includeLinks: Bool
    
    func run() throws {
        let library = try MusicLibrary()
        guard let list = library.findPlaylist(named: playlistName) else {
            throw RuntimeError("Playlist not found.")
        }
        let database = includeLinks ? try SQLiteDatabase() : nil
        let folder = Folder.current
        let file = try folder.createFile(named: playlistName + ".md")
        let formatter = includeRatings ? FiveStarRatingFormatter() : nil
        guard let body = list.asMarkdown(ratingFormatter: formatter, usingLinkStore: database) else {
            throw RuntimeError("Unable to generate playlist body.")
        }
        try file.write(body)
    }
}
