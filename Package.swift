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
        .package(url: "https://github.com/ZipArchive/ZipArchive.git", from: "2.2.0"),
    ],
    targets: [
        .target(
            name: "ChattyWebviews",
            exclude: [],
            path: "ChattyWebviews"
        )
    ]
)