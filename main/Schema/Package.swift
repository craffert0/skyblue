// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Schema",
    products: [
        .library(
            name: "Schema",
            targets: ["Schema"],
        ),
    ],

    dependencies: [
        .package(path: "../SkyBlueApi"),
    ],

    targets: [
        .target(
            name: "Schema",
            dependencies: [
                .product(name: "SkyBlueApi", package: "SkyBlueApi"),
            ],
        ),
        .testTarget(
            name: "SchemaTests",
            dependencies: [
                "Schema",
                .product(name: "SkyBlueApi", package: "SkyBlueApi"),
            ],
        ),
    ]
)
