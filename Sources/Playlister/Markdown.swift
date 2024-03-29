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
    
    @Flag(name: [.long, .customShort("r")]) var includeRatings: Bool
    @Flag(name: [.long, .customShort("l")]) var includeLinks: Bool
    @Flag(name: [.long, .customShort("s")], help: "Attempt to remove affiliate tokens from generated links. Ignored if not including links.") var stripAffiliateTokens: Bool
    
    func run() throws {
        #if os(macOS)
        let library = try MusicLibrary()
        guard let list = library.findPlaylist(named: playlistName) else {
            throw RuntimeError("Playlist not found.")
        }
        let database = includeLinks ? try SQLiteDatabase(interactive: true) : nil
        let folder = Folder.current
        let file = try folder.createFile(named: playlistName + ".md")
        let formatter = includeRatings ? FiveStarRatingFormatter() : nil
        guard let body = list.asMarkdown(ratingFormatter: formatter, usingLinkStore: database, stripAffiliateTokens: stripAffiliateTokens) else {
            throw RuntimeError("Unable to generate playlist body.")
        }
        try file.write(body)
        #else
        throw RuntimeError("Unsupported operating system!")
        #endif
    }
}
