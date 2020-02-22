import SwiftCLI
import Foundation
import Files

class GenerateCommand : Command {
    
    @Key("-o", "--output", description: "Output directory; defaults to ./playlists") var outputPath: String?
    @Flag("-r", "--ratings", description: "Include star ratings") var includeRatings: Bool
    @Flag("-g", "--git", description: "Git add/commit/push the result") var doGit: Bool
    @Key("-m", "--message", description: "Message to use with git commit. Ignored if -g not specified. Defaults to 'Automated update'.") var commitMessage: String?
    
    
    let name = "generate"
    let shortDescription = "Generate all playlists as markdown"
    let longDescription = "Output all playlists as markdown files in their full hierarchical structure."
    
    func execute() throws {
        // TODO: All the git stuff
        let library = try Library()
        
        let rootFolder: Folder
        if let outPath = outputPath {
            rootFolder = try Folder(path: outPath)
        } else {
            rootFolder = try Folder.current.createSubfolderIfNeeded(at: "playlists")
        }
        if (doGit){
            let gitInit = Task(executable: "git", arguments: ["init"], directory: rootFolder.path, stdout: stdout, stderr: stderr, stdin: ReadStream.stdin)
            gitInit.runSync()
            let gitClear = Task(executable: "git", arguments: ["rm", "-rf", "."], directory: rootFolder.path, stdout: stdout, stderr: stderr, stdin: ReadStream.stdin)
            gitClear.runSync()
            let gitClean = Task(executable: "git", arguments: ["clean", "-fxd"], directory: rootFolder.path, stdout: stdout, stderr: stderr, stdin: ReadStream.stdin)
            gitClean.runSync()
        }
        for playlist in library.playlists {
            try playlist.printPlaylist(in: rootFolder, includeRating: includeRatings)
        }
    }
}

fileprivate extension Playlist {
    func printPlaylist(in folder: Folder, includeRating: Bool = false) throws {
        if isParent {
            // create directory and recurse
            let subdir = try folder.createSubfolderIfNeeded(at: name)
            for child in children {
                try child.printPlaylist(in: subdir, includeRating: includeRating)
            }
        } else {
            guard let body = try asMarkdown(includeRating: includeRating) else {
                // TODO: Log this in some way
                return
            }
            
            let file = try folder.createFileIfNeeded(withName: "\(name).md")
            try file.write(body)
        }
    }
}
