extension app.bsky.actor {
    public class getPreferencesResult: Codable {
        public let preferences: [app.bsky.actor.preference]
    }

    public enum preference: Codable {
        case adultContentPref(AdultContentPref)
        case contentLabelPref(ContentLabelPref)
        case savedFeedsPref(SavedFeedsPref)
        case savedFeedsPrefV2(SavedFeedsPrefV2)
        case personalDetailsPref(PersonalDetailsPref)
        case feedViewPref(FeedViewPref)
        case threadViewPref(ThreadViewPref)
        case interestsPref(InterestsPref)
        case mutedWordsPref(MutedWordsPref)
        case hiddenPostsPref(HiddenPostsPref)
        case bskyAppStatePref(BskyAppStatePref)
        case labelersPref(LabelersPref)
        case unknown(String)

        public init(from decoder: Decoder) throws {
            let typename = try? decoder.singleValueContainer().decode(TypeName.self).typename
            if typename == "app.bsky.actor.defs#adultContentPref" {
                self = try .adultContentPref(decoder.singleValueContainer().decode(AdultContentPref.self))
            } else if typename == "app.bsky.actor.defs#contentLabelPref" {
                self = try .contentLabelPref(decoder.singleValueContainer().decode(ContentLabelPref.self))
            } else if typename == "app.bsky.actor.defs#savedFeedsPref" {
                self = try .savedFeedsPref(decoder.singleValueContainer().decode(SavedFeedsPref.self))
            } else if typename == "app.bsky.actor.defs#savedFeedsPrefV2" {
                self = try .savedFeedsPrefV2(decoder.singleValueContainer().decode(SavedFeedsPrefV2.self))
            } else if typename == "app.bsky.actor.defs#personalDetailsPref" {
                self = try .personalDetailsPref(decoder.singleValueContainer().decode(PersonalDetailsPref.self))
            } else if typename == "app.bsky.actor.defs#feedViewPref" {
                self = try .feedViewPref(decoder.singleValueContainer().decode(FeedViewPref.self))
            } else if typename == "app.bsky.actor.defs#threadViewPref" {
                self = try .threadViewPref(decoder.singleValueContainer().decode(ThreadViewPref.self))
            } else if typename == "app.bsky.actor.defs#interestsPref" {
                self = try .interestsPref(decoder.singleValueContainer().decode(InterestsPref.self))
            } else if typename == "app.bsky.actor.defs#mutedWordsPref" {
                self = try .mutedWordsPref(decoder.singleValueContainer().decode(MutedWordsPref.self))
            } else if typename == "app.bsky.actor.defs#hiddenPostsPref" {
                self = try .hiddenPostsPref(decoder.singleValueContainer().decode(HiddenPostsPref.self))
            } else if typename == "app.bsky.actor.defs#bskyAppStatePref" {
                self = try .bskyAppStatePref(decoder.singleValueContainer().decode(BskyAppStatePref.self))
            } else if typename == "app.bsky.actor.defs#labelersPref" {
                self = try .labelersPref(decoder.singleValueContainer().decode(LabelersPref.self))
            } else {
                self = .unknown(typename ?? "??")
            }
        }
    }

    public class AdultContentPref: Codable {
        public let enabled: Bool
    }

    public class ContentLabelPref: Codable {
        public let label: String
        public let visibility: String // "knownValues": ["ignore", "show", "warn", "hide"]
        public let labelerDid: String?
    }

    public class SavedFeedsPref: Codable {
        public let pinned: [String]
        public let saved: [String]
        public let timelineIndex: Int?
    }

    public class SavedFeedsPrefV2: Codable {
        public let items: [savedFeed]
    }

    public class PersonalDetailsPref: Codable {
        public let birthDate: String?
    }

    public class FeedViewPref: Codable {
        public let feed: String
        public let hideReplies: Bool?
        public let hideRepliesByUnfollowed: Bool?
        public let hideRepliesByLikeCount: Bool?
        public let hideReposts: Bool?
        public let hideQuotePosts: Bool?
    }

    public class ThreadViewPref: Codable {
        public let sort: String?
        public let prioritizeFollowedUsers: Bool?
    }

    public class InterestsPref: Codable {
        public let tags: [String]
    }

    public class MutedWordsPref: Codable {
        public let items: [MutedWord]
    }

    public class MutedWord: Codable {
        public let id: String?
        public let value: String
        public let targets: [String]
        public let actorTarget: String?
        public let expiresAt: String?
    }

    public enum MutedWordTarget: Codable {
        case content
        case tag
    }

    public class HiddenPostsPref: Codable {
        public let items: [String]
    }

    public class BskyAppStatePref: Codable {
        // public let activeProgressGuide
        public let queuedNudges: [String]?
        public let nuxs: [Nux]?
    }

    public class Nux: Codable {
        public let id: String
        public let completed: Bool
        public let data: String?
        public let expiresAt: String?
    }

    public class LabelersPref: Codable {
        public let labelers: [LabelerPrefItem]
    }

    // ----------------
    public class savedFeed: Codable {
        public let id: String
        public let type: String
        public let value: String
        public let pinned: Bool
    }

    public class LabelerPrefItem: Codable {
        public let did: String
    }
}

extension app.bsky.actor {
    public class profileViewBasic: Codable {
        public let did: String // format: did
        public let handle: String // format: handle

        public let displayName: String?
        // public let avatar: String?             // format: uri
        public let associated: profileAssociated?
        // NOTE: viewerState is in both .feed and .actor, but we're namespaced
        public let viewer: viewerState?
        public let labels: [label]?
        public let createdAt: String? // format: datetime
    }
}

// NOTE: two different viewerState in two different namespaces works nicely
extension app.bsky.actor {
    public class viewerState: Codable {
        public let muted: Bool?
        public let mutedByList: listViewBasic?
        public let blockedBy: Bool?
        public let blocking: String? // format": "at-uri" },
        public let blockingByList: listViewBasic?
        public let following: String? // "format": "at-uri" },
        public let followedBy: String? // "format": "at-uri" },
        public let knownFollowers: knownFollowers?
    }
}
