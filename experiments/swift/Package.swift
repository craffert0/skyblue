// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "top10",

    platforms: [.macOS(.v15)],

    products: [
        .library(
            name: "Proto",
            targets: ["Proto"]
        ),
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/immobiliare/RealHTTP.git", from: "1.9.0"),
        .package(path: "../../main/Schema/"),
    ],

    targets: [
        .executableTarget(
            name: "Main",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "RealHTTP", package: "realhttp"),
                .product(name: "Schema", package: "schema"),
                "Proto",
            ]
        ),
        .executableTarget(
            name: "Top",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Schema", package: "schema"),
                "Proto",
            ]
        ),
        .testTarget(
            name: "MainTests",
            dependencies: ["Main"]
        ),
        .target(
            name: "Proto"),
    ]
)
