// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

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
            HStack {
                Text(feed_post.post.indexedAt.relative())
                Text(feed_post.post.author.my_name)
            }
            if let feedContext = feed_post.feedContext {
                Text(feedContext)
            }
        }
    }
}

#Preview {
    let json = """
      [
          {
              "post": {
                  "author": {
                      "did": "did:plc:yobyqjt4hs5icoihvaombhhn",
                      "handle": "lolgop.bsky.social",
                      "displayName": "L O L G O P",
                      "avatar": "https://cdn.bsky.app/img/avatar/plain/did:plc:yobyqjt4hs5icoihvaombhhn/bafkreihicmgnhrjxzbsioorjsxtiqvsgrcyvmalxurh7vcxlhmivbm5uua@jpeg",
                      "createdAt": "2023-05-15T00:24:38.616Z"
                  },
                  "cid": "bafyreif75qiwoqg4pwu3gnqkvoyh5apq5y2hjw26dxcnydggeg4l6knkj4",
                  "indexedAt": "2025-03-05T16:03:49.022Z",
                  "uri": "at://did:plc:yobyqjt4hs5icoihvaombhhn/app.bsky.feed.post/3ljne6iss5g2t",
                  "record": {
                      "$type": "app.bsky.feed.post",
                      "createdAt": "2025-03-05T16:03:48.652Z",
                      "text": "The State of the Union is that mutherfucker gets to give the State of the Union."
                  },
              }
          },

          {
              "post": {
                  "author": {
                      "did": "did:plc:mvjetxlhl54i2dau6slwqwia",
                      "handle": "colinbwilliams.com",
                      "displayName": "ℭ𝔬𝔩𝔦𝔫",
                      "avatar": "https://cdn.bsky.app/img/avatar/plain/did:plc:mvjetxlhl54i2dau6slwqwia/bafkreiav4fglatzyli3skwl2lt3ypdyjlz7wawlmrp7sqevtjitijhlcdi@jpeg",
                      "createdAt": "2023-08-02T03:18:09.185Z"
                  },

                  "cid": "bafyreih334czripfeyw27xlidpgykigd5sxe5gwcq5hn4lhfrkargk6lre",
                  "indexedAt": "2025-03-05T13:47:41.117Z",
                  "uri": "at://did:plc:mvjetxlhl54i2dau6slwqwia/app.bsky.feed.post/3ljn4kzsndc22",
                  "record": {
                      "$type": "app.bsky.feed.post",
                      "createdAt": "2025-03-05T13:47:39.465Z",
                      "embed": {
                          "$type": "app.bsky.embed.external",
                          "external": {
                              "description": "\\"Trump take egg\\" ... and we're seeing the effects here in Pittsburgh.",
                              "thumb": {
                                  "$type": "blob",
                                  "ref": {
                                      "$link": "bafkreiceitsb23s5wzkhayh5dg5wqasoqeomkxnvfbdcjw4ittt2nv3nzu"
                                  },
                                  "mimeType": "image/jpeg",
                                  "size": 383973
                              },
                              "title": "Trump\u{201}9s policies and avian flu are driving egg prices up \u{201}4 and begetting plenty of memes",
                              "uri": "https://www.pghcitypaper.com/news/trumps-policies-and-avian-flu-are-driving-egg-prices-up-and-begetting-plenty-of-memes-27607711"
                          }
                      },
                      "facets": [
                          {
                              "features": [
                                  {
                                      "$type": "app.bsky.richtext.facet#link",
                                      "uri": "https://www.pghcitypaper.com/news/trumps-policies-and-avian-flu-are-driving-egg-prices-up-and-begetting-plenty-of-memes-27607711"
                                  }
                              ],
                              "index": {
                                  "byteEnd": 51,
                                  "byteStart": 15
                              }
                          }
                      ],
                      "langs": [
                          "en"
                      ],
                      "text": "Trump take egg\\nwww.pghcitypaper.com/news/trumps-..."
                  },
                  "embed": {
                      "$type": "app.bsky.embed.external#view",
                      "external": {
                          "uri": "https://www.pghcitypaper.com/news/trumps-policies-and-avian-flu-are-driving-egg-prices-up-and-begetting-plenty-of-memes-27607711",
                          "title": "Trump\u{201}9s policies and avian flu are driving egg prices up \u{201}4 and begetting plenty of memes",
                          "description": "\\"Trump take egg\\" ... and we're seeing the effects here in Pittsburgh.",
                          "thumb": "https://cdn.bsky.app/img/feed_thumbnail/plain/did:plc:mvjetxlhl54i2dau6slwqwia/bafkreiceitsb23s5wzkhayh5dg5wqasoqeomkxnvfbdcjw4ittt2nv3nzu@jpeg"
                      }
                  },
                  "replyCount": 0,
                  "repostCount": 2,
                  "likeCount": 8,
                  "quoteCount": 0,
              },
              "reason": {
                  "$type": "app.bsky.feed.defs#reasonRepost",
                  "by": {
                      "did": "did:plc:swgxwbir4rrimj57pf75jckf",
                      "handle": "mtsw.bsky.social",
                      "displayName": "mtsw",
                      "avatar": "https://cdn.bsky.app/img/avatar/plain/did:plc:swgxwbir4rrimj57pf75jckf/bafkreihqtmxhaoustvuuaaagsztjbjyrgu65rl4bh5olfeav4mas673vpy@jpeg",
                      "associated": {
                          "chat": {
                              "allowIncoming": "all"
                          }
                      },
                      "createdAt": "2023-04-11T20:06:26.779Z"
                  },
                  "indexedAt": "2025-03-05T16:03:48.025Z"
              }
          }
      ]
    """

    let posts = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601WithFractionalSeconds
        return try! d.decode([FeedViewPostView.FeedViewPost].self,
                             from: Data(json.utf8))
    }()
    VStack {
        ForEach(posts) {
            FeedViewPostView($0)
        }
    }
}
