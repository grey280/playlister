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
        let plays: Int
        if let artistName = artistName{
            plays = try getPlays(artistName)
        } else {
            let name = Input.readLine(prompt: "Which artist?", secure: false)
            plays = try getPlays(name)
        }
        let amountApplePaysPerStream = 0.0056
        let total = amountApplePaysPerStream * Double(plays)
        stdout <<< "\(name) has \(plays) plays total, which is approximately $\(total)"
    }
    
    let name = "income"
    
    let shortDescription: String = "Estimate the amount of money an artist has made from you listening to their music."
    
    func getPlays(_ artistName: String) throws -> Int {
        let library = try Library()
        let findArtist = library.artists.first { (art) -> Bool in
            art.name == artistName
        }
        guard let artist = findArtist else {
            return 0
        }
        return library.songs
            .filter { $0.artist == artist }
            .map { $0.playCount }
            .reduce(0, +)
    }
}
