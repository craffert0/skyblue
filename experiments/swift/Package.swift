// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "top10",

    platforms: [.macOS(.v15)],

    dependencies: [
        .package(url: "https://github.com/immobiliare/RealHTTP.git", from: "1.9.0"),
    ],

    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "top10",
            dependencies: [
                .product(name: "RealHTTP", package: "realhttp"),
            ]
        ),
        .testTarget(
            name: "tests",
            dependencies: ["top10"]
        ),
    ]
)
