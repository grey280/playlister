import SwiftCLI
import Foundation
import Files

class GenerateCommand : Command {
    
    @Key("-o", "--output", description: "Output directory; defaults to ./playlists") var outputPath: String?
    
    
    let name = "generate"
    let shortDescription = "Generate all playlists as markdown"
    let longDescription = "Output all playlists as markdown files in their full hierarchical structure"
    
    func execute() throws {
        // TODO: Implement
    }
}
