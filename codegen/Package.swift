// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "codegen",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser",
                 from: "1.3.0"),
        .package(path: "../main/BlueSkyApi"),
    ],
    targets: [
        .executableTarget(
            name: "codegen",
            dependencies: [
                .product(name: "ArgumentParser",
                         package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "tests",
            dependencies: [
                "codegen",
                .product(name: "BlueSkyApi", package: "BlueSkyApi"),
            ],
            resources: [
                .process("Inputs/Timeline.Output.1.json"),
                .process("Inputs/top1.json"),
                .process("Inputs/top10.json"),
                .process("Inputs/top97.json"),
                .process("Inputs/top970.json"),
            ],
        ),
    ]
)
