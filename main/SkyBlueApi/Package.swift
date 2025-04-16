// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SkyBlueApi",
    products: [
        .library(
            name: "SkyBlueApi",
            targets: ["SkyBlueApi"]
        ),
    ],
    targets: [
        .target(
            name: "SkyBlueApi"),
        .testTarget(
            name: "SkyBlueApiTests",
            dependencies: ["SkyBlueApi"]
        ),
    ]
)
