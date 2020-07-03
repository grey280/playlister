//
//  LinkStore.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//
import Foundation

public protocol LinkStore {
    /// Return a URL (possibly interactively) for an item
    /// - Parameter for: item to get the link
    func link(for: PlaylistItem) throws -> URL?
    
    
    /// Update (or set) the link for an item
    /// - Parameters:
    ///   - for: item to save the link - if not already in the database, will insert
    ///   - url: URL to store.
    func link(for: PlaylistItem, url: URL) throws 
}
