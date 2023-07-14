// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "ChattyWebviews",
    platforms: [
        .macOS(.v10_14), .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "ChattyWebviews",
            targets: ["ChattyWebviews"])
    ],
    dependencies: [
        .package(url: "https://github.com/ZipArchive/ZipArchive.git", from: "2.4.2")
    ],
    targets: [
        .target(
            name: "ChattyWebviews",
            dependencies: ["ZipArchive"],
            path: "ChattyWebviews",
            exclude: []
            
        )
    ]
)