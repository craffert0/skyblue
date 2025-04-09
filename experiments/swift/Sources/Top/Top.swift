// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import ArgumentParser
import Foundation
import Proto
import Schema
import System

typealias FeedViewPost = app.bsky.feed.defs.FeedViewPost
typealias GetTimeline = app.bsky.feed.GetTimeline

extension FeedViewPost: @retroactive Identifiable {
    public var id: String {
        if let reason {
            switch reason {
            case let .app_bsky_feed_defs_reasonRepost(repost):
                "\(post.cid).repost.\(repost.by.handle)"
            case .app_bsky_feed_defs_reasonPin:
                "\(post.cid).pin"
            case let .unknown(u):
                "\(post.cid).unknown.\(u)"
            }
        } else {
            post.cid
        }
    }
}

@main
struct Top: AsyncParsableCommand {
    @Argument(transform: FilePath.init(stringLiteral:))
    var file: FilePath

    func run() throws {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601WithFractionalSeconds
        let posts =
            try d.decode(
                GetTimeline.Output.self,
                from: FileManager.default.contents(atPath: file.string)!
            ).feed
        var idMap: [String: [FeedViewPost]] = [:]
        for p in posts {
            idMap[p.id] = (idMap[p.id] ?? []) + [p]
        }
        for (k, v) in idMap {
            if v.count > 1 {
                print("================")
                print("\(v.count) \(k)")
                print("================")
                for p in v {
                    try p.dumpJson()
                    print("================")
                }
                print("================")
            }
        }
    }
}
