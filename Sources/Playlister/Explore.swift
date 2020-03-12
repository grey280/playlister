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
        subcommands: [ArtistIncome.self]
    )
}

struct ArtistIncome: ParsableCommand {
    @Argument(help: ArgumentHelp("Name of the artist to view.", discussion: "")) var artistName: String
    
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "income", abstract: "Estimate the amount of money an artist has made from you listening to their music.")
    
    func run() throws {
        let plays = try getPlays(artistName)
        let amountApplePaysPerStream = 0.0056 // Citation: https://soundcharts.com/blog/music-streaming-rates-payouts/
        let total = amountApplePaysPerStream * Double(plays)
        print("\(artistName) has \(plays) plays, which is approximately $\(String(format: "%.2f", total))")
    }
    
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
}
