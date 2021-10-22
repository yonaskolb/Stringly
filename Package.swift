// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Stringly",
    products: [
        .executable(name: "stringly", targets: ["Stringly"]),
        .library(name: "StringlyKit", targets: ["StringlyKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams", from: "1.0.0"),
        .package(url: "https://github.com/kylef/PathKit", from: "1.0.1"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.1.0"),
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.3"),
        .package(url: "https://github.com/dduan/TOMLDeserializer", from: "0.2.4"),
        .package(url: "https://github.com/yonaskolb/Codability", from: "0.2.1"),
    ],
    targets: [
        .target(
            name: "Stringly",
            dependencies: ["StringlyCLI"]),
        .target(
            name: "StringlyCLI",
            dependencies: [
                "Yams",
                "Rainbow",
                "SwiftCLI",
                "PathKit",
                "TOMLDeserializer",
                "StringlyKit",
        ]),
        .target(
            name: "StringlyKit",
            dependencies: ["Codability"]),
        .testTarget(
            name: "StringlyCLITests",
            dependencies: ["StringlyCLI", "PathKit"]),
        .testTarget(
            name: "StringlyKitTests",
            dependencies: ["StringlyKit", "PathKit"]),
    ]
)
