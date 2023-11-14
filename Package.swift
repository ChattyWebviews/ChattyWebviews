// swift-tools-version:5.7
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
    ],,
    targets: [
        .target(
            name: "ChattyWebviews",
            dependencies: [],
            path: "ChattyWebviews",
            exclude: []
            
        )
    ]
)