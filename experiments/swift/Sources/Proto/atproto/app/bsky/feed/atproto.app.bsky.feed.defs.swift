extension atproto.app.bsky.feed {
    public class feedViewPost: Codable {
        // enum reasonEnum: String, Codable {
        //     case reasonRepost reasonPin
        // }

        // NOTE: no need to qualify namespace since it's the same
        public let post: postView
        // reply: replyRef?
        // reason: reasonEnum?
        public let feedContext: String?
    }

    public class postView: Codable {
        public let uri: String // format: at-uri
        public let cid: String // format: cid
        // NOTE: fully-qualified different namespace
        public let author: atproto.app.bsky.actor.profileViewBasic
        // record: Any
        public let indexedAt: String // format: datetime

        // embed: Any?

        public let replyCount: Int?
        public let repostCount: Int?
        public let likeCount: Int?
        public let quoteCount: Int?
        // NOTE: viewerState is in both .feed and .actor, but we're namespaced
        public let viewer: viewerState?
        public let labels: [label]?
        public let threadgate: threadgateView?
    }
}

// NOTE: two different viewerState in two different namespaces works nicely
extension atproto.app.bsky.feed {
    public class viewerState: Codable {
        public let repost: String? // format": "at-uri" },
        public let like: String? // "format": "at-uri" },
        public let threadMuted: Bool?
        public let replyDisabled: Bool?
        public let embeddingDisabled: Bool?
        public let pinned: Bool?
    }
}
