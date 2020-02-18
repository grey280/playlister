import SwiftCLI
import Foundation
import Files

class GenerateCommand : Command {
    
    @Key("-o", "--output", description: "Output directory; defaults to ./playlists") var outputPath: String?
    
    
    let name = "generate"
    let shortDescription = "Generate all playlists as markdown"
    let longDescription = "Output all playlists as markdown files in their full hierarchical structure"
    
    func execute() throws {
        let library = try Library()
        
        let rootFolder: Folder
        if let outPath = outputPath {
            rootFolder = try Folder(path: outPath)
        } else {
            rootFolder = try Folder.current.createSubfolderIfNeeded(at: "playlists")
        }
        // TODO: Generate all playlists!
    }
}
