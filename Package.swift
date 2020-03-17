// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let linkerSettings: [LinkerSetting]?
#if os(macOS)
linkerSettings = [.linkedFramework("iTunesLibrary")]
#else
linkerSettings = nil
#endif

let package = Package(
    name: "Playlister",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "playlister", targets: ["Playlister"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0"),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.12.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Playlister",
            dependencies: ["Files", "SQLite", "LibPlaylister", "ShellOut", .product(name: "ArgumentParser", package: "swift-argument-parser")],
            linkerSettings: linkerSettings
        ),
        .target(
            name: "LibPlaylister",
            dependencies: ["Files", "SQLite"]
        ),
        .testTarget(
            name: "LibPlaylisterTests",
            dependencies: ["LibPlaylister"]),
    ]
)
