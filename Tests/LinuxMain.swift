import XCTest

import LibPlaylisterTests

var tests = [XCTestCaseEntry]()
tests += LibraryTests.allTests()
tests += HelperTests.allTests()
XCTMain(tests)
