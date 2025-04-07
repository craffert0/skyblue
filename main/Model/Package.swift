// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Model",

    platforms: [.iOS(.v17), .macOS(.v14)],

    products: [
        .library(
            name: "Model",
            targets: ["Model"]
        ),
    ],

    dependencies: [
        .package(path: "../Schema"),
    ],

    targets: [
        .target(
            name: "Model",
            dependencies: [
                "Schema",
            ]
        ),
        .testTarget(
            name: "ModelTests",
            dependencies: ["Model"]
        ),
    ]
)
