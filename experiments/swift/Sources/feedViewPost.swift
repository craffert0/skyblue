class feedViewPost: Codable {
    // enum reasonEnum: String, Codable {
    //     case reasonRepost reasonPin
    // }

    let post: postView
    // reply: replyRef?
    // reason: reasonEnum?
    let feedContext: String?
}

class postView: Codable {
    let uri: String // format: at-uri
    let cid: String // format: cid
    let author: profileViewBasic
    // record: Any
    let indexedAt: String // format: datetime

    // embed: Any?

    let replyCount: Int?
    let repostCount: Int?
    let likeCount: Int?
    let quoteCount: Int?
    let viewer: feed_viewerState?
    let labels: [label]?
    let threadgate: threadgateView?
}

class threadgateView: Codable {
    let uri: String? // format: at-uri
    let cid: String? // format: cid
    // "record": { "type": "unknown" },
    let lists: [listViewBasic]?
}

// class replyRef: Codable {
//     enum replyType: String, Codable {
//         case postView", "#notFoundPost", "#blockedPost

//     root:
//       parent:
//       grandparentAuthor: profileViewBasic?
//           "type": "ref",
//           "ref": "app.bsky.actor.defs#profileViewBasic",

// }

class profileViewBasic: Codable {
    let did: String // format: did
    let handle: String // format: handle

    let displayName: String?
    // let avatar: String?             // format: uri
    let associated: profileAssociated?
    let viewer: actor_viewerState?
    let labels: [label]?
    let createdAt: String?          // format: datetime
}

class profileAssociated: Codable {
    let lists: Int?
    let feedgens: Int?
    let starterPacks: Int?
    let labeler: Bool?
    let chat: profileAssociatedChat?
}

class profileAssociatedChat: Codable {
    enum allowIncomingEnum: String, Codable {
        case all, none, following
    }

    let allowIncoming: allowIncomingEnum
}

class actor_viewerState: Codable {
    let muted: Bool?
    let mutedByList: listViewBasic?
    let blockedBy: Bool?
    let blocking: String? // format": "at-uri" },
    let blockingByList: listViewBasic?
    let following: String? // "format": "at-uri" },
    let followedBy: String? // "format": "at-uri" },
    let knownFollowers: knownFollowers?
}

class feed_viewerState: Codable {
    let repost: String?         // format": "at-uri" },
    let like: String?           // "format": "at-uri" },
    let threadMuted: Bool?
    let replyDisabled: Bool?
    let embeddingDisabled: Bool?
    let pinned: Bool?
}

class knownFollowers: Codable {
    let count: Int
    let followers: [profileViewBasic]
}

class listViewBasic: Codable {
    let uri: String // format": "at-uri" },
    let cid: String // format: cid
    let name: String
    let purpose: listPurpose

    let avatar: String? // format": "uri" },
    let listItemCount: Int?
    let labels: [label]?
    let viewer: listViewerState?
    let indexedAt: String? // format: datetime
}

enum listPurpose: String, Codable {
    case modlist, curatelist, referencelist
}

class label: Codable {
    // ["src", "uri", "val", "cts"],
    let src: String // format": "did"
    let uri: String // format: uri
    let val: String
    let cts: String // format: datetime

    let ver: Int?
    let cid: String?
    let neg: Bool?
    let exp: String?
    // sig: bytes
}

class listViewerState: Codable {
    let muted: Bool?
    let blocked: String? // format": "at-uri" }
}
