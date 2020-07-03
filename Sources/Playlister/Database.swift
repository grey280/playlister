//
//  DatabaseInitCommand.swift
//  Files
//
//  Created by Grey Patterson on 2/16/20.
//

import Foundation
import ArgumentParser
import LibPlaylister

struct Database: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "db",
        abstract: "Manage the links database",
        subcommands: [DatabaseReset.self, DatabaseUpdate.self]
    )
}

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

struct DatabaseUpdate: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(
        commandName: "update",
        abstract: "Update the link for a track"
    )
    
    @Argument() var songID: Int
    @Argument() var url: String
    
    func run() throws {
        #if os(macOS)
        guard let url = URL(string: url) else {
            throw RuntimeError("Could not parse URL")
        }
        let library = try MusicLibrary()
        guard let item = library.items.filter({ (item) -> Bool in
            item.id == songID
        }).first else {
            throw RuntimeError("Track not found")
        }
        let database = try SQLiteDatabase(interactive: false)
        try database.link(for: item, url: url)
        #else
        throw RuntimeError("Unsupported operating system!")
        #endif
    }
}
