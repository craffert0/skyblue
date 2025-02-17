// TODO: This should be in the proper namespaces

public class threadgateView: Codable {
    public let uri: String? // format: at-uri
    public let cid: String? // format: cid
    // "record": { "type": "unknown" },
    public let lists: [listViewBasic]?
}

// public class replyRef: Codable {
//     enum replyType: String, Codable {
//         case postView", "#notFoundPost", "#blockedPost

//     root:
//       parent:
//       grandparentAuthor: profileViewBasic?
//           "type": "ref",
//           "ref": "app.bsky.actor.defs#profileViewBasic",

// }

public class profileAssociated: Codable {
    public let lists: Int?
    public let feedgens: Int?
    public let starterPacks: Int?
    public let labeler: Bool?
    public let chat: profileAssociatedChat?
}

public class profileAssociatedChat: Codable {
    public enum allowIncomingEnum: String, Codable {
        case all, none, following
    }

    public let allowIncoming: allowIncomingEnum
}

public class knownFollowers: Codable {
    public let count: Int
    public let followers: [app.bsky.actor.profileViewBasic]
}

public class listViewBasic: Codable {
    public let uri: String // format": "at-uri" },
    public let cid: String // format: cid
    public let name: String
    public let purpose: listPurpose

    public let avatar: String? // format": "uri" },
    public let listItemCount: Int?
    public let labels: [label]?
    public let viewer: listViewerState?
    public let indexedAt: String? // format: datetime
}

public enum listPurpose: String, Codable {
    case modlist, curatelist, referencelist
}

public class label: Codable {
    // ["src", "uri", "val", "cts"],
    public let src: String // format": "did"
    public let uri: String // format: uri
    public let val: String
    public let cts: String // format: datetime

    public let ver: Int?
    public let cid: String?
    public let neg: Bool?
    public let exp: String?
    // sig: bytes
}

public class listViewerState: Codable {
    public let muted: Bool?
    public let blocked: String? // format": "at-uri" }
}
