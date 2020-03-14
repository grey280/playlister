//
//  LinkStore.swift
//  Files
//
//  Created by Grey Patterson on 3/11/20.
//
import Foundation

public protocol LinkStore {
    func link(for: PlaylistItem) throws -> URL?
}
