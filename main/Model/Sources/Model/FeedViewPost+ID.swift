// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

extension app.bsky.feed.defs.FeedViewPost: @retroactive Identifiable {
    public var id: String {
        if let reason {
            switch reason {
            case let .reasonRepost(repost):
                "\(post.cid).repost.\(repost.by.handle)"
            case .reasonPin:
                "\(post.cid).pin"
            case let .unknown(u):
                "\(post.cid).unknown.\(u)"
            }
        } else {
            post.cid
        }
    }
}
