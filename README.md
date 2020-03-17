# Playlister

A command-line tool for reading your iTunes/Music.app playlists.

## Features
* `list`
List all of your playlists. Optionally using a nice nesting format, to be easier to read.
* `md`
Spit out a single playlist as a Markdown file. Use `-r` to include ratings on the five-star scale, and `-l` to interactively attach links to each item. Links are stored in a database (in `~/.playlister/`) for reuse the next time you run `md -l`.
* `generate`
Spit out all your playlists as Markdown files, hierarchically-organized, in `./playlists/` Can non-interactively add links, where present in the database (`-l`), and optionally track the whole thing in git (`-g`), including fetch/pull/push, if you configure the git repository for it. (Note: doesn't handle merge conflicts.)
* `db`
Manage the database. For now, only includes a helper to wipe the whole thing; in the future, would like to add features for managing single entries.

## Built on...
* [John Sundell](https://www.swiftbysundell.com/articles/building-a-command-line-tool-using-the-swift-package-manager/)'s advice
* [SQLite.swift](https://github.com/stephencelis/SQLite.swift)
* [Files](https://github.com/JohnSundell/Files)
* [ShellOut](https://github.com/JohnSundell/ShellOut)
* [ArgumentParser](https://github.com/apple/swift-argument-parser)
