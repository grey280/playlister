//
//  LibraryTests.swift
//  PlaylisterTests
//
//  Created by Grey Patterson on 3/16/20.
//

import XCTest
import LibPlaylister

class LibraryTests: XCTestCase {
    var library: TestLibrary?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.library = TestLibrary()
        let list1 = TestPlaylist()
        list1.name = "List 1"
        list1.id = 1
        let list2 = TestPlaylist()
        list2.name = "List 2"
        list2.id = 2
        self.library?.playlists = [list1, list2]
    }

    func testFindPlaylist() {
        let list1 = self.library?.playlists[0]
        XCTAssertEqual(list1?.id, self.library?.findPlaylist(named: "List 1")?.id)
        let list2 = self.library?.playlists[1]
        XCTAssertEqual(list2?.id, self.library?.findPlaylist(named: "List 2")?.id)
        XCTAssertNil(self.library?.findPlaylist(named: "Not Present"))
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
