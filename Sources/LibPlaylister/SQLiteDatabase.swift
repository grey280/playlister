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

extension SQLiteDatabase: LinkStore{
    public func link(for item: PlaylistItem) -> URL? {
        guard let db = database else {
            // TODO: Log the error in some way
            return nil
        }
        let table = Table("links")
        let id = Expression<Int>("id")
        let link = Expression<URL?>("link")
        if let row = try? database.prepare(table.filter(id == item.id).limit(1)).first(where: { (_) -> Bool in
            true
        }) {
            return row[link]
        } else {
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
        return nil // should never actually happen but here we are
    }
}
