//
//  Explore.swift
//  ArgumentParser
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation
import LibPlaylister
import ArgumentParser


struct Explore: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "explore",
        abstract: "Explore your library",
        subcommands: [ArtistIncome.self, SongIDs.self]
    )
}

struct ArtistIncome: ParsableCommand {
    @Argument(help: ArgumentHelp("Name of the artist to view.", discussion: "")) var artistNames: [String]
    
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "income", abstract: "Estimate the amount of money an artist has made from you listening to their music.")
    
    func run() throws {
        #if os(macOS)
        let artistName: String = artistNames.joined(separator: " ")
        let plays = try getPlays(artistName)
        let amountApplePaysPerStream = 0.0056 // Citation: https://soundcharts.com/blog/music-streaming-rates-payouts/
        let total = amountApplePaysPerStream * Double(plays)
        print("\(artistName) has \(plays) plays, which is approximately $\(String(format: "%.2f", total))")
        #else
        throw RuntimeError("Unsupported operating system!")
        #endif
    }
    
    #if os(macOS)
    private func getPlays(_ artistName: String) throws -> Int {
        let library = try MusicLibrary()
        let findArtist = library.artists.first { (art) -> Bool in
            art.name == artistName
        }
        guard let artist = findArtist else {
            // TODO: Log that they weren't found
            return 0
        }
        return library.items
            .filter { $0.artist?.id == artist.id }
            .map { $0.playCount }
            .reduce(0, +)
    }
    #endif
}

struct SongIDs: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "id", abstract: "See the song IDs of every song in a playlist")
    
    @Argument() var playlistName: String
    
    func run() throws {
        #if os(macOS)
        let library = try MusicLibrary()
        guard let list = library.findPlaylist(named: playlistName) else {
            throw RuntimeError("Playlist not found.")
        }
        let result = list.items.map { "\($0.title ?? "Unknown Title") by \($0.artist?.name ?? "Unknown Artist") - [\($0.id)]"}.joined(separator: "\n")
        print(result)
        #else
        throw RuntimeError("Unsupported operating system!")
        #endif
    }
}
