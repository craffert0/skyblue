// lexicons/app/bsky/feed/getTimeline.json
extension atproto.app.bsky.feed {
    public struct GetTimeline {
        public class Output: Codable {
            public let cursor: String
            public let feed: [feedViewPost]
        }
    }
}
