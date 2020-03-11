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
    
    func initialize(_ deletingOld: Bool) throws {
        if (deletingOld){
            try file.delete()
        }
        let db = try Connection(file.path)
        let links = Table("links")
        let id = Expression<Int64>("id")
        let link = Expression<String?>("link")
        try db.run(links.create { t in
            t.column(id, primaryKey: true)
            t.column(link)
        })
    }
}


extension URL: Value {
    public static let declaredDatatype: String = "TEXT"
    public typealias Datatype = String
    public var datatypeValue: String {
        self.absoluteString
    }
    public static func fromDatatypeValue(_ datatypeValue: String) -> URL {
        URL(string: datatypeValue)!
    }
}
