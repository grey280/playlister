//import SwiftCLI
//
//let cli = CLI(name: "playlister", version: "2.0.0", description: "A tool for tracking your iTunes/Music.app playlists as they change over time.", commands: [MarkdownCommand(), ListCommand(), GenerateCommand(), ExploreCommandGroup()])
//cli.aliases["e"] = "explore"
//cli.aliases["db"] = "database"
//let _ = cli.go()
//
//

import ArgumentParser

struct CLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "playlister",
        abstract: "A command-line tool for reading your iTunes/Music.app playlists",
        subcommands: [Database.self]
    )
}
CLI.main()
