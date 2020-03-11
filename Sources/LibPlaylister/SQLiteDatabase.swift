//
//  SQLiteDatabase.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation
import Files
import SQLite

public struct SQLiteDatabase{
    let file: File
    
    public init(_ with: File){
        self.file = with
    }
    public init() throws {
        self.file = try Folder.home
            .createSubfolderIfNeeded(at: ".playlister")
            .createFileIfNeeded(at: "links.sqlite3")
    }
}
