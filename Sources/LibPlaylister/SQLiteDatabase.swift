//
//  SQLiteDatabase.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//

import Foundation
import Files
import SQLite

public class SQLiteDatabase{
    let file: File
    var database: Connection!
    
    public init(_ with: File) throws{
        self.file = with
        try initialize()
    }
    public init() throws {
        self.file = try Folder.home
            .createSubfolderIfNeeded(at: ".playlister")
            .createFileIfNeeded(at: "links.sqlite3")
        try initialize()
    }
    
    public func resetDatabase() throws {
        database = nil
        try file.delete()
        try initialize()
    }
    
    func initialize() throws {
        database = try Connection(file.path)
        let links = Table("links")
        let id = Expression<Int>("id")
        let link = Expression<URL?>("link")
        try database.run(links.create(ifNotExists: true) { t in
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
