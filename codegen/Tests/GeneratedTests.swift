// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import BlueSkyApi
import Foundation
import Testing

@Suite struct GeneratedTests {
    @Test func parse() throws {
        let service = FakeService()
        let timeline: app.bsky.GetTimeline.Output =
            try #require(try service.get(name: "Timeline.Output.1"))
        #expect(timeline.cursor == "abcd")
        try #require(timeline.feed.count == 1)
        let fvpost = timeline.feed.first!
        #expect(fvpost.post.author.handle == "tomscocca.bsky.social")
        try #require(fvpost.reason != nil)
        guard case let .reasonRepost(repost) = fvpost.reason else {
            Issue.record("post is not a repost")
            return
        }
        #expect(repost.by.displayName == "ItsEasyBeingGreen")
    }
}
