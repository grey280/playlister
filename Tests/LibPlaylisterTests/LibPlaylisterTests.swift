import XCTest
import LibPlaylister
import class Foundation.Bundle

final class LibPlaylisterTests: XCTestCase {
    func testMarkdownSafe() throws {
        let string1 = "F**k Collingwood"
        let string1safe = #"F\*\*k Collingwood"#
        XCTAssertEqual(string1safe, string1.markdownSafe)
        let string2 = "Nothing problematic here"
        XCTAssertEqual(string2, string2.markdownSafe)
        let string3 = "This has [an insertion]"
        let string3safe = #"This has \[an insertion\]"#
        XCTAssertEqual(string3safe, string3.markdownSafe)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("Playlister")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Hello, world!\n")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
