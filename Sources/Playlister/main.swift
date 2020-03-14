//import SwiftCLI
//
//let cli = CLI(name: "playlister", version: "2.0.0", description: "A tool for tracking your iTunes/Music.app playlists as they change over time.", commands: [GenerateCommand()])
//let _ = cli.go()

import ArgumentParser

struct CLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "playlister",
        abstract: "A command-line tool for reading your iTunes/Music.app playlists",
        subcommands: [Database.self, Explore.self, List.self, Markdown.self]
    )
}
CLI.main()
