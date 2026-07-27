// swift-tools-version:6.4

/**
*  Publish
*  Copyright (c) John Sundell 2019
*  MIT license, see LICENSE file for details
*/

import PackageDescription

let package = Package(
    name: "Publish",
    // Files requires iOS 18 / tvOS 18 / watchOS 11 (Synchronization.Mutex).
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(name: "Publish", targets: ["Publish"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/brightdigit/Ink.git",
            from: "1.0.0-alpha.1"
        ),
        .package(
            url: "https://github.com/brightdigit/Plot.git",
            from: "1.0.0-alpha.1"
        ),
        .package(
            url: "https://github.com/brightdigit/Files.git",
            from: "5.0.0-alpha.1"
        )
    ],
    targets: [
        .target(
            name: "Publish",
            dependencies: [
                "Ink", "Plot", "Files"
            ]
        ),
        .testTarget(
            name: "PublishTests",
            dependencies: ["Publish"]
        )
    ]
)
