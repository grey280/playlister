//
//  LibraryTests.swift
//  PlaylisterTests
//
//  Created by Grey Patterson on 3/16/20.
//

import XCTest
import LibPlaylister

class LibraryTests: XCTestCase {
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class TestLibrary: Library {    
    typealias PlaylistType = TestPlaylist
    var artists: [Artist] = []
    var playlists: [TestPlaylist] = []
    var items: [PlaylistItem] = []
}

final class TestPlaylist: Playlist {
    var id: Int = 0
    var children: [TestPlaylist] = []
    var parentID: Int?
    var name: String = ""
    var items: [PlaylistItem] = []
}

class TestArtist: Artist {
    var id: Int = 0
    var name: String?
}

class TestAlbum: Album {
    var id: Int = 0
    var name: String?
}

class TestPlaylistItem: PlaylistItem {
    var id: Int = 0
    var rating: Int?
    var artist: Artist?
    var title: String?
    var album: Album?
    var playCount: Int = 0
}
