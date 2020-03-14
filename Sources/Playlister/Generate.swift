//
//  Generate.swift
//  Playlister
//
//  Created by Grey Patterson on 3/14/20.
//

import LibPlaylister
import ArgumentParser
import ShellOut
import Files

struct Generate: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(commandName: "generate", abstract: "Generate all playlists as markdown.", discussion: "Creates a full hierarchy of all your (normal, so excluding things like Purchased) playlists, as markdown files.\nAll generation happens in a ./playlists directory.\nAfter generation, will optionally attempt to add, commit, and push changes to the ./playlists directory as a git repository.")
    
    @Flag(name: [.long, .customShort("r")]) var includeRatings: Bool
    @Flag(name: [.long, .customShort("l")], help: "Non-interactively include links. To fill the links database, use the 'md' command.") var includeLinks: Bool
    @Flag(name: [.long, .customShort("g")]) var git: Bool
    
    @Option(name: .long, default: "\"Automated update\"", help: "Commit message to use when in git mode.") var commitMessage: String
    
    func run() throws {
        let library = try MusicLibrary()
        let didExist = Folder.current.containsSubfolder(named: "playlists")
        let rootFolder = try Folder.current.createSubfolderIfNeeded(at: "playlists")
        if (git){
            try shellOut(to: "git", arguments: ["init"], at: rootFolder.path)
            let _ = try? shellOut(to: "git", arguments: ["fetch"], at: rootFolder.path)
            let _ = try? shellOut(to: "git", arguments: ["pull"], at: rootFolder.path)
            if (didExist){
                try shellOut(to: "git", arguments: ["rm", "-rf", "."], at: rootFolder.path)
                try shellOut(to: "git", arguments: ["clean", "-fxd"], at: rootFolder.path)
            }
        }
        let database = includeLinks ? try SQLiteDatabase(interactive: false) : nil
        let formatter = includeRatings ? FiveStarRatingFormatter() : nil
        for playlist in library.playlists {
            try playlist.printPlaylist(in: rootFolder, ratingFormatter: formatter, linkStore: database)
        }
        if (git) {
            try shellOut(to: "git", arguments: ["add", "."], at: rootFolder.path)
            let _ = try? shellOut(to: "git", arguments: ["commit", "-m", commitMessage], at: rootFolder.path)
            let _ = try? shellOut(to: "git", arguments: ["push"], at: rootFolder.path)
        }
    }
}

fileprivate extension Playlist {
    func printPlaylist(in folder: Folder, ratingFormatter: RatingFormatter?, linkStore: LinkStore?) throws {
        if isParent {
            // create directory and recurse
            let subdir = try folder.createSubfolderIfNeeded(at: name)
            for child in children {
                try child.printPlaylist(in: subdir, ratingFormatter: ratingFormatter, linkStore: linkStore)
            }
        } else {
            guard let body = asMarkdown(ratingFormatter: ratingFormatter, usingLinkStore: linkStore) else {
                throw RuntimeError("Unable to generate playlist body.")
            }
            let file = try folder.createFileIfNeeded(withName: "\(name).md")
            try file.write(body)
        }
    }
}
