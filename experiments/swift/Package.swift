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
        .package(url: "https://github.com/immobiliare/RealHTTP.git", from: "1.9.0"),
    ],

    targets: [
        .executableTarget(
            name: "Main",
            dependencies: [
                .product(name: "RealHTTP", package: "realhttp"),
                "Proto",
            ]
        ),
        .testTarget(
            name: "MainTests",
            dependencies: ["Main"]
        ),
        .target(
            name: "Proto"),
        .testTarget(
            name: "ProtoTests",
            dependencies: ["Proto"]
        ),
    ]
)
