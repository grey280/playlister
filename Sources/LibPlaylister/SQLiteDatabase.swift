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
    
    let interactive: Bool
    
    public init(_ with: File, interactive: Bool = false) throws{
        self.file = with
        self.interactive = interactive
        try initialize()
    }
    public init(interactive: Bool = false) throws {
        self.file = try Folder.home
            .createSubfolderIfNeeded(at: ".playlister")
            .createFileIfNeeded(at: "links.sqlite3")
        self.interactive = interactive
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

extension SQLiteDatabase: LinkStore{
    public func link(for item: PlaylistItem) throws -> URL? {
        guard let db = database else {
            throw RuntimeError("Unable to connect to links database.")
        }
        let table = Table("links")
        let id = Expression<Int>("id")
        let link = Expression<URL?>("link")
        if let row = try? database.prepare(table.filter(id == item.id).limit(1)).first(where: { (_) -> Bool in
            true
        }) {
            return row[link]
        } else if (interactive){
            var input: String?
            while (input == nil){
                print("What link would you like to use for \(item.asMarkdown(ratingFormatter: nil, usingLinkStore: nil))? (Leave blank for no link.)")
                input = readLine(strippingNewline: true)
                if (input == nil) {
                    continue
                }
                let url: URL? = input == "" ? nil : URL(string: input!)
                let insert = table.insert(id <- item.id, link <- url)
                let _ = try? db.run(insert)
                return url
            }
        }
        return nil
    }
    
    public func link(for item: PlaylistItem, url: URL) throws {
        guard let db = database else {
            throw RuntimeError("Unable to connect to links database.")
        }
        let table = Table("links")
        let id = Expression<Int>("id")
        let link = Expression<URL?>("link")
        
        if let count = try? database.scalar(table.filter(id == item.id).count), count > 0 {
            let update = table.filter(id == item.id).update(link <- url)
            try db.run(update)
        } else {
            let insert = table.insert(id <- item.id, link <- url)
            try db.run(insert)
        }
    }
}
