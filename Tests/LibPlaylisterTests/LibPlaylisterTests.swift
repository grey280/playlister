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

    static var allTests = [
        ("testMarkdownSafe", testMarkdownSafe),
    ]
}
