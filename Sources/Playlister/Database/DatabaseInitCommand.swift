//
//  DatabaseInitCommand.swift
//  Files
//
//  Created by Grey Patterson on 2/16/20.
//

import Foundation
import SwiftCLI
import Files

class DatabaseInitCommand: Command {
    let name = "init"
    let shortDescription: String = "Initialize the database"
    
    func execute() throws {
        let workDir = try Folder.home.createSubfolderIfNeeded(at: ".playlister")
        // TODO: Create the SQLite database in that directory
    }
}
