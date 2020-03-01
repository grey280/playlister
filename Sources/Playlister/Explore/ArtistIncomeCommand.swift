//
//  ArtistIncomeCommand.swift
//  Files
//
//  Created by Grey Patterson on 2/29/20.
//

import SwiftCLI
import Foundation

// TODO: This should take an artist name, then get all their songs, and then total up the counts across all of those, and finally multiply it by Apple Music's 'payout per artist' thing

class ArtistIncomeCommand: Command {
    @Param var artistName: String?
    
    func execute() throws {
        let artist = artistName ?? Input.readLine(prompt: "Which artist?")
        let plays = try getPlays(artist)
        
        let amountApplePaysPerStream = 0.0056 // Citation: https://soundcharts.com/blog/music-streaming-rates-payouts/
        let total = amountApplePaysPerStream * Double(plays)
        stdout <<< "\(artist) has \(plays) plays total, which is approximately $\(String(format: "%.2f", total))"
    }
    
    let name = "income"
    
    let shortDescription: String = "Estimate the amount of money an artist has made from you listening to their music."
    
    func getPlays(_ artistName: String) throws -> Int {
        let library = try Library()
        let findArtist = library.artists.first { (art) -> Bool in
            art.name == artistName
        }
        guard let artist = findArtist else {
//            stderr <<< "Unable to find artist \(artistName)"
            return 0
        }
//        stdout <<< "Found artist, has ID \(artist.persistentID)"
        return library.songs
            .filter { $0.artist?.persistentID == artist.persistentID }
            .map { $0.playCount }
            .reduce(0, +)
    }
}
