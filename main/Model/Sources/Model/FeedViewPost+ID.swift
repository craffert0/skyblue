// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

// TODO: need more proper unique id
extension app.bsky.feed.defs.FeedViewPost: @retroactive Identifiable {
    public var id: String { post.cid }
}
