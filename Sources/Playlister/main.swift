import ArgumentParser

struct CLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "playlister",
        abstract: "A command-line tool for reading your iTunes/Music.app playlists",
        subcommands: [Database.self, Explore.self, List.self, Markdown.self, Generate.self]
    )
}
CLI.main()
