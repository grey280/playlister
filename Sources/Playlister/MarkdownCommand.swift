import SwiftCLI
import Foundation

class MarkdownCommand: Command {
    let name = "md"
    let shortDescription = "Generate Markdown files of playlists."
    
    // Base output path to use when generating
    @Param var path: String
    
    @Flag("-r", "--rating", description: "Include star ratings in output") var rating: Bool
    
    @Key("-m", "--message", description: "Message to use when committing to Git repository.") var gitMessage: String?
    
    func execute() throws {
        let library = try Library()
        let filemanager = FileManager.default
        let inp = PipeStream()
        let outp = PipeStream()
        let gitInit = Task(executable: "git", arguments: ["init"], directory: path, stdout: outp, stderr: stderr, stdin: inp)
        gitInit.runSync()
//        let gitClear = Task(executable: "git", arguments: ["rm", "-rf", "."], directory: path, stdout: inp, stderr: stderr, stdin: outp)
//        gitClear.runSync()
//        let gitClean = Task(executable: "git", arguments: ["clean", "-fxd"], directory: path, stdout: outp, stderr: stderr, stdin: inp)
//        gitClean.runSync()
        
        for playlist in library.playlists {
            playlist.printPlaylist(in: path, with: filemanager)
        }
        
        let gitAdd = Task(executable: "git", arguments: ["add", "."], directory: path, stdout: outp, stderr: stderr, stdin: inp)
        gitAdd.runSync()
        let gitCommit = Task(executable: "git", arguments: ["commit", "-m", gitMessage ?? "Automated update"], directory: path, stdout: outp, stderr: stderr, stdin: inp)
        gitCommit.runSync()
        let gitPush = Task(executable: "git", arguments: ["push"], directory: path, stdout: outp, stderr: stderr, stdin: inp)
        gitPush.runSync()
    }
}

fileprivate extension String{
    var markdownSafe: String{
        return self.replacingOccurrences(of: "*", with: "\\*").replacingOccurrences(of: "[", with: "\\[").replacingOccurrences(of: "]", with: "\\]")
    }
}

fileprivate extension Playlist {
    func asMarkdown(includeRating: Bool) -> String? {
        if isParent {
            return nil
        }
        let body = origin.items.map({ (item) -> String in
            let title = item.title.markdownSafe
            let artist = item.artist?.name
            let album: String? = (item.album.title?.isEmpty ?? true) ? nil : item.album.title
            if (includeRating){
                let rating = printedRating(item.isRatingComputed ? 0 : item.rating)
                if let artist = artist {
                    guard let alb = album else {
                        return "**\(title)** - \(artist.markdownSafe) (\(rating))"
                    }
                    return "**\(title)** - \(artist.markdownSafe) on *\(alb.markdownSafe)* (\(rating))"
                }
                guard let alb = album else {
                    return "**\(title)** - Unknown Artist (\(rating))"
                }
                return "**\(title)** - Unknown Artist on *\(alb.markdownSafe)* (\(rating))"
            } else {
                if let artist = artist {
                    guard let alb = album else {
                        return "**\(title)** - \(artist.markdownSafe)"
                    }
                    return "**\(title)** - \(artist.markdownSafe) on *\(alb.markdownSafe)*"
                }
                guard let alb = album else {
                    return "**\(title)** - Unknown Artist"
                }
                return "**\(title)** - Unknown Artist on *\(alb.markdownSafe)*"
            }
            
        }).joined(separator: "\n\n")
        return "# \(name)\n\n\(body)\n"
    }
    
    func printPlaylist(in path: String, with filemanager: FileManager, includeRating: Bool = false){
        if isParent{
            // create directory and recurse
            let newPath = "\(path)/\(name)"
            if (!filemanager.fileExists(atPath: newPath)){
                do {
                    try filemanager.createDirectory(atPath: newPath, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    FileHandle.standardError.write("Error: failed to create directory \(newPath)".data(using: .utf8)!)
                    exit(1)
                }
            }
            for child in children{
                child.printPlaylist(in: newPath, with: filemanager)
            }
        } else {
            // print the playlist!
            let newFileName = "\(path)/\(name).md"
            if (filemanager.fileExists(atPath: newFileName)){
                print("Removing file \(newFileName) for overwriting")
                do{
                    try filemanager.removeItem(atPath: newFileName)
                }catch let error{
                    FileHandle.standardError.write("Error: failed to remove file \(newFileName)".data(using: .utf8)!);
                    FileHandle.standardError.write(error.localizedDescription.data(using: .utf8)!)
                    exit(1)
                }
            }
            // build the file contents
            guard let body = asMarkdown(includeRating: includeRating) else {
                FileHandle.standardError.write("Error: failed to build playlist descriptor \(newFileName)".data(using: .utf8)!);
                exit(1)
            }
            //   write to the file
            guard filemanager.createFile(atPath: newFileName, contents: body.data(using: .utf8)!, attributes: nil) else{
                FileHandle.standardError.write("Error: failed to write file \(newFileName)".data(using: .utf8)!);
                exit(1)
            }
        }
    }
}
