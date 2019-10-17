// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stringly",
    products: [
        .executable(name: "stringly", targets: ["Stringly"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams", from: "1.0.0"),
        .package(url: "https://github.com/kylef/PathKit", from: "0.9.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.1.0"),
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.2.0"),
    ],
    targets: [
        .target(
            name: "Stringly",
            dependencies: ["StringlyCLI"]),
        .target(
            name: "StringlyCLI",
            dependencies: ["Yams", "Rainbow", "SwiftCLI", "PathKit"]),
        .testTarget(
            name: "StringlyCLITests",
            dependencies: ["StringlyCLI"]),
    ]
)
