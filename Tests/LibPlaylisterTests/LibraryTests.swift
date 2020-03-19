//
//  LibraryTests.swift
//  PlaylisterTests
//
//  Created by Grey Patterson on 3/16/20.
//

import XCTest
@testable import LibPlaylister

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
        let parentList = TestPlaylist()
        parentList.name = "Parent"
        parentList.id = 3
        let child1 = TestPlaylist()
        child1.name = "Child 1"
        child1.id = 4
        let child2 = TestPlaylist()
        child2.name = "Child 2"
        child2.id = 5
        parentList.children = [child1, child2]
        self.library?.playlists = [list1, list2, parentList]
    }

    func testFindPlaylist() {
        let list1 = self.library?.playlists[0]
        XCTAssertEqual(list1?.id, self.library?.findPlaylist(named: "List 1")?.id)
        let list2 = self.library?.playlists[1]
        XCTAssertEqual(list2?.id, self.library?.findPlaylist(named: "List 2")?.id)
        XCTAssertNil(self.library?.findPlaylist(named: "Not Present"))
        let child1 = self.library?.playlists[2].children[0]
        XCTAssertEqual(child1?.id, self.library?.findPlaylist(named: "Child 1")?.id)
    }
    
    func testParentRelationships() {
        let parent = self.library?.playlists[2]
        XCTAssert(parent?.isParent ?? false)
        let idToFind = 4
        let found = self.library?.playlists.compactMap {$0.findPlaylist(idToFind) }.first
        XCTAssertNotNil(found)
        XCTAssertEqual(idToFind, found?.id)
    }
    
    func testItemAsBasicMarkdown() {
        let item = TestPlaylistItem()
        XCTAssertEqual(#"**(Untitled item)** - Unknown artist"#, item.asMarkdown())
        item.title = "Song Name"
        XCTAssertEqual("**Song Name** - Unknown artist", item.asMarkdown())
        item.artist = TestArtist(id: 0, name: "Artist Name")
        XCTAssertEqual(#"**Song Name** - Artist Name"#, item.asMarkdown())
        item.album = TestAlbum(id: 0, name: "Album Name")
        XCTAssertEqual(#"**Song Name** - Artist Name on *Album Name*"#, item.asMarkdown())
    }
    
    func testFiveStar() {
        let formatter = FiveStarRatingFormatter()
        XCTAssertEqual("☆☆☆☆☆", formatter.format(0))
        XCTAssertEqual("★★★★★", formatter.format(100))
        XCTAssertEqual("★★★☆☆", formatter.format(60))
        XCTAssertEqual("★★☆☆☆", formatter.format(59))
        XCTAssertEqual("☆☆☆☆☆", formatter.format(-10))
        XCTAssertEqual("★★★★★", formatter.format(1000))
    }
    
    func testItemAsRatedMarkdown() {
        let item = TestPlaylistItem()
        item.title = "Song Name"
        item.artist = TestArtist(id: 0, name: "Artist Name")
        item.album = TestAlbum(id: 0, name: "Album Name")
        let formatter = FiveStarRatingFormatter()
        XCTAssertEqual(#"**Song Name** - Artist Name on *Album Name* (☆☆☆☆☆)"#, item.asMarkdown(ratingFormatter: formatter))
        item.rating = 0
        XCTAssertEqual(#"**Song Name** - Artist Name on *Album Name* (☆☆☆☆☆)"#, item.asMarkdown(ratingFormatter: formatter))
        item.rating = 100
        XCTAssertEqual(#"**Song Name** - Artist Name on *Album Name* (★★★★★)"#, item.asMarkdown(ratingFormatter: formatter))
    }
    
    func testItemWithLinks() {
        let item = TestPlaylistItem()
        item.title = "Song Name"
        item.artist = TestArtist(id: 0, name: "Artist Name")
        item.album = TestAlbum(id: 0, name: "Album Name")
        let store = TestLinkStore()
        XCTAssertEqual(#"[**Song Name** - Artist Name on *Album Name*](https://greypatterson.me/)"#, item.asMarkdown(usingLinkStore: store))
    }
}

class TestLinkStore: LinkStore {
    func link(for: PlaylistItem) throws -> URL? {
        URL(string: "https://greypatterson.me/")
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

struct TestArtist: Artist {
    var id: Int = 0
    var name: String?
}

struct TestAlbum: Album {
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
