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
        subcommands: []
    )
}

struct ArtistIncome: ParsableCommand {
    @Argument(help: ArgumentHelp("Name of the artist to view.", discussion: "")) var artistName: String
    
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "income", abstract: "Estimate the amount of money an artist has made from you listening to their music.")
    
    func run() throws {
        
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



/*
 
 struct DatabaseReset: ParsableCommand {
     static var configuration = CommandConfiguration(
         commandName: "reset",
         abstract: "Reset the links database"
     )
     
     func run() throws {
         let database = try SQLiteDatabase()
         try database.resetDatabase()
     }
 }

 */
