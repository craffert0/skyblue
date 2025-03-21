// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData

@Model
public class FeedModel {
    public typealias FeedViewPost = app.bsky.feed.defs.FeedViewPost

    public var feed: [FeedViewPost] = []

    init() {}
}
