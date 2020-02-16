// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Playlister",
    platforms: [
        .macOS(.v10_13)
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Playlister",
            dependencies: ["SwiftCLI"],
            linkerSettings: [
                .linkedFramework("iTunesLibrary")
            ]),
        .testTarget(
            name: "PlaylisterTests",
            dependencies: ["Playlister"]),
    ]
)
