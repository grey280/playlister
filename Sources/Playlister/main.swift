import SwiftCLI

let cli = CLI(name: "playlister", version: "2.0.0", description: "A tool for tracking your iTunes/Music.app playlists as they change over time.", commands: [MarkdownCommand(), ListCommand(), GenerateCommand(), DatabaseCommandGroup(), ExploreCommandGroup()])
cli.aliases["e"] = "explore"
let _ = cli.go()
