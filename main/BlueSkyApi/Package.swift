// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BlueSkyApi",
    products: [
        .library(
            name: "BlueSkyApi",
            targets: ["BlueSkyApi"]
        ),
    ],
    targets: [
        .target(
            name: "BlueSkyApi"),
        .testTarget(
            name: "BlueSkyApiTests",
            dependencies: ["BlueSkyApi"]
        ),
    ]
)
