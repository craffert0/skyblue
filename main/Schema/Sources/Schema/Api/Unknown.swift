// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SkyBlueApi

// TODO: This needs to be updated to have many more cases, or even actually
// doing it properly.

@frozen public enum Unknown: Codable {
    case post(app.bsky.feed.post.Main)
    case threadgate(app.bsky.feed.threadgate.Main)
    case starterpack(app.bsky.graph.starterpack.Main)
    case unknown(String)

    public init(from decoder: Decoder) throws {
        let typename = try? decoder.singleValueContainer().decode(TypeName.self).typename
        switch typename {
        case "app.bsky.feed.post":
            self = try .post(decoder.singleValueContainer().decode(app.bsky.feed.post.Main.self))
        case "app.bsky.feed.threadgate":
            self = try .threadgate(decoder.singleValueContainer().decode(app.bsky.feed.threadgate.Main.self))
        case "app.bsky.graph.starterpack":
            self = try .starterpack(decoder.singleValueContainer().decode(app.bsky.graph.starterpack.Main.self))
        default:
            self = .unknown(typename ?? "??")
        }
    }
}
