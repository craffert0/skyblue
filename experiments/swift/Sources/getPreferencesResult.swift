// See jsonTest.swift top-level comment for how this works.

struct TypeName: Codable {
    let typename: String
    enum CodingKeys: String, CodingKey {
        case typename = "$type"
    }
}

extension atproto.app.bsky.actor {
    class getPreferencesResult: Codable {
        let preferences: [atproto.app.bsky.actor.preference]
    }

    enum preference: Codable {
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

        init(from decoder: Decoder) throws {
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

    class AdultContentPref: Codable {
        let enabled: Bool
    }

    class ContentLabelPref: Codable {
        let label: String
        let visibility: String // "knownValues": ["ignore", "show", "warn", "hide"]
        let labelerDid: String?
    }

    class SavedFeedsPref: Codable {
        let pinned: [String]
        let saved: [String]
        let timelineIndex: Int?
    }

    class SavedFeedsPrefV2: Codable {
        let items: [savedFeed]
    }

    class PersonalDetailsPref: Codable {
        let birthDate: String?
    }

    class FeedViewPref: Codable {
        let feed: String
        let hideReplies: Bool?
        let hideRepliesByUnfollowed: Bool?
        let hideRepliesByLikeCount: Bool?
        let hideReposts: Bool?
        let hideQuotePosts: Bool?
    }

    class ThreadViewPref: Codable {
        let sort: String?
        let prioritizeFollowedUsers: Bool?
    }

    class InterestsPref: Codable {
        let tags: [String]
    }

    class MutedWordsPref: Codable {
        let items: [MutedWord]
    }

    class MutedWord: Codable {
        let id: String?
        let value: String
        let targets: [String]
        let actorTarget: String?
        let expiresAt: String?
    }

    enum MutedWordTarget: Codable {
        case content
        case tag
    }

    class HiddenPostsPref: Codable {
        let items: [String]
    }

    class BskyAppStatePref: Codable {
        // let activeProgressGuide
        let queuedNudges: [String]?
        let nuxs: [Nux]?
    }

    class Nux: Codable {
        let id: String
        let completed: Bool
        let data: String?
        let expiresAt: String?
    }

    class LabelersPref: Codable {
        let labelers: [LabelerPrefItem]
    }

    // ----------------
    class savedFeed: Codable {
        let id: String
        let type: String
        let value: String
        let pinned: Bool
    }

    class LabelerPrefItem: Codable {
        let did: String
    }
}
