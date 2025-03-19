// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

extension app.bsky.actor.defs.ProfileViewBasic {
    var my_name: String {
        if let displayName {
            "\(displayName) (\(handle))"
        } else {
            handle
        }
    }
}

struct FeedViewPostView: View {
    typealias FeedViewPost = app.bsky.feed.defs.FeedViewPost

    @State var feed_post: FeedViewPost

    init(_ feed_post: FeedViewPost) {
        self.feed_post = feed_post
    }

    var body: some View {
        VStack {
            Text(feed_post.post.author.my_name)
            Text(feed_post.post.indexedAt.formatted())
            if let feedContext = feed_post.feedContext {
                Text(feedContext)
            }
        }
    }
}

#Preview {
    let author = app.bsky.actor.defs.ProfileViewBasic(did: "",
                                                      handle: "al@bsky",
                                                      displayName: "Al Franken")
    let post = app.bsky.feed.defs.PostView(author: author,
                                           cid: "cid",
                                           indexedAt: Date.now,
                                           record: .unknown("?"),
                                           uri: "uri")
    FeedViewPostView(app.bsky.feed.defs.FeedViewPost(post: post,
                                                     feedContext: "context"))
}
