//
//  DatabaseInitCommand.swift
//  Files
//
//  Created by Grey Patterson on 2/16/20.
//

import Foundation
import SwiftCLI
import Files
import SQLite

class DatabaseInitCommand: Command {
    let name = "init"
    let shortDescription: String = "Initialize the database"
    
    @Flag("-h", "--hard", description: "Delete the existing database") var hard: Bool
    
    func execute() throws {
        let workDir = try Folder.home.createSubfolderIfNeeded(at: ".playlister")
        if (hard) {
            if let oldDB = try? workDir.file(at: "links.sqlite3"){
                try oldDB.delete()
            }
        }
        
        let db = try Connection("\(workDir.path)/links.sqlite3")
        let links = Table("links")
        let id = Expression<Int64>("id")
        let link = Expression<String?>("link")
        try db.run(links.create { t in
            t.column(id, primaryKey: true)
            t.column(link)
        })
    }
}
