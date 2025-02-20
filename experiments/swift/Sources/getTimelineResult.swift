class getTimelineResult: Codable {
    let cursor: String
    let feed: [atproto.app.bsky.feed.feedViewPost]
}
