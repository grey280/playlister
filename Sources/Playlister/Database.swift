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
        subcommands: [DatabaseReset.self]
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
