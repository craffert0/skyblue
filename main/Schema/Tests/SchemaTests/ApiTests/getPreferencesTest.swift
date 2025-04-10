import Foundation
import Schema
import Testing

@Test func parsePrefs() throws {
    // This is from running top10.py + `print(json.dumps(server.getPreferences(), indent=2))`

    let input = """
    {
        "preferences": [
          {
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "hate"
          },
          {
              "label": "spam",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "visibility": "warn"
          },
          {
              "enabled": true,
              "$type": "app.bsky.actor.defs#adultContentPref"
          },
          {
              "visibility": "ignore",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "nudity"
          },
          {
              "label": "suggestive",
              "visibility": "ignore",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "$type": "app.bsky.actor.defs#bskyAppStatePref",
              "nuxs": [
                {
                    "completed": true,
                    "id": "TenMillionDialog"
                },
                {
                    "completed": true,
                    "id": "NeueTypography"
                }
              ]
          },
          {
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "panda-pandas"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "visibility": "warn",
              "label": "extremist"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "visibility": "warn",
              "label": "threat"
          },
          {
              "visibility": "warn",
              "label": "rude",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "visibility": "warn",
              "label": "illicit"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "visibility": "warn",
              "label": "security"
          },
          {
              "label": "unsafe-link",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "visibility": "warn"
          },
          {
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "impersonation"
          },
          {
              "visibility": "warn",
              "label": "scam",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "engagement-farming"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "spam",
              "visibility": "warn"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "porn",
              "visibility": "ignore"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "visibility": "ignore",
              "label": "nsfw"
          },
          {
              "visibility": "ignore",
              "label": "graphic-media",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "label": "gore",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "visibility": "ignore"
          },
          {
              "lab_treeViewEnabled": false,
              "$type": "app.bsky.actor.defs#threadViewPref"
          },
          {
              "items": [
                {
                    "actorTarget": "all",
                    "id": "3lbkozhoc222z",
                    "targets": [
                      "tag",
                      "content"
                    ],
                    "value": "bleagh"
                }
              ],
              "$type": "app.bsky.actor.defs#mutedWordsPref"
          },
          {
              "label": "bad-selfies",
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "label": "cringe",
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "cryptid",
              "visibility": "warn"
          },
          {
              "label": "jeremy",
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "mutual-aid"
          },
          {
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "reposts-without-likes"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "watermarks",
              "visibility": "warn"
          },
          {
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "bluesky-elder"
          },
          {
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "dinosaur-emoji"
          },
          {
              "label": "disinformation-network",
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "visibility": "warn",
              "label": "elon-musk",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "label": "fringe-media",
              "visibility": "warn",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "visibility": "warn",
              "label": "maga-trump",
              "$type": "app.bsky.actor.defs#contentLabelPref"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "nazi-symbolism",
              "visibility": "warn"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "rmve-imve",
              "visibility": "warn"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "visibility": "warn",
              "label": "terf-gc"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "troll",
              "visibility": "warn"
          },
          {
              "$type": "app.bsky.actor.defs#savedFeedsPrefV2",
              "items": [
                {
                    "value": "following",
                    "id": "3l4kjyjskzs2d",
                    "pinned": true,
                    "type": "timeline"
                },
                {
                    "value": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/whats-hot",
                    "id": "3l4kjyjskzt2d",
                    "type": "feed",
                    "pinned": true
                },
                {
                    "type": "feed",
                    "id": "3l4kjyjskzu2d",
                    "pinned": true,
                    "value": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/with-friends"
                },
                {
                    "pinned": true,
                    "value": "at://did:plc:tenurhgjptubkk5zf5qhi3og/app.bsky.feed.generator/mutuals",
                    "type": "feed",
                    "id": "3larft5son22a"
                },
                {
                    "type": "feed",
                    "id": "3laytaf3nsk2a",
                    "value": "at://did:plc:d2hstwsgopddotavgl5xgrfs/app.bsky.feed.generator/aaaczxd252ey4",
                    "pinned": true
                },
                {
                    "pinned": true,
                    "id": "3lbqpkgejks2g",
                    "value": "at://did:plc:vpkhqolt662uhesyj6nxm7ys/app.bsky.feed.generator/infreq",
                    "type": "feed"
                },
                {
                    "value": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/bsky-team",
                    "type": "feed",
                    "pinned": false,
                    "id": "3l4kjyjskzv2d"
                },
                {
                    "type": "feed",
                    "pinned": false,
                    "value": "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/hot-classic",
                    "id": "3l4kjyjskzw2d"
                }
              ]
          },
          {
              "$type": "app.bsky.actor.defs#savedFeedsPref",
              "saved": [
                "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/bsky-team",
                "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/with-friends",
                "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/whats-hot",
                "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/hot-classic",
                "at://did:plc:tenurhgjptubkk5zf5qhi3og/app.bsky.feed.generator/mutuals",
                "at://did:plc:d2hstwsgopddotavgl5xgrfs/app.bsky.feed.generator/aaaczxd252ey4",
                "at://did:plc:vpkhqolt662uhesyj6nxm7ys/app.bsky.feed.generator/infreq"
              ],
              "pinned": [
                "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/whats-hot",
                "at://did:plc:z72i7hdynmk6r22z27h6tvur/app.bsky.feed.generator/with-friends",
                "at://did:plc:tenurhgjptubkk5zf5qhi3og/app.bsky.feed.generator/mutuals",
                "at://did:plc:d2hstwsgopddotavgl5xgrfs/app.bsky.feed.generator/aaaczxd252ey4",
                "at://did:plc:vpkhqolt662uhesyj6nxm7ys/app.bsky.feed.generator/infreq"
              ]
          },
          {
              "$type": "app.bsky.actor.defs#labelersPref",
              "labelers": [
                {
                    "did": "did:plc:wkoofae5uytcm7bjncmev6n6"
                },
                {
                    "did": "did:plc:i65enriuag7n5fgkopbqtkyk"
                },
                {
                    "did": "did:plc:newitj5jo3uel7o4mnf3vj2o"
                },
                {
                    "did": "did:plc:bpkpvmwpd3nr2ry4btt55ack"
                },
                {
                    "did": "did:plc:wp7hxfjl5l4zlptn7y6774lk"
                },
                {
                    "did": "did:plc:4cbvrwtii4d5p4hymgu5sv2q"
                },
                {
                    "did": "did:plc:4ugewi6aca52a62u62jccbl7"
                },
                {
                    "did": "did:plc:gqaoe3na6isc3zyvp7iuqpu7"
                },
                {
                    "did": "did:plc:skibpmllbhxvbvwgtjxl3uao"
                },
                {
                    "did": "did:plc:e4elbtctnfqocyfcml6h2lf7"
                },
                {
                    "did": "did:plc:d2mkddsbmnrgr3domzg5qexf"
                },
                {
                    "did": "did:plc:4nkfpe7ty5lye5doc2dv5qpv"
                },
                {
                    "did": "did:plc:qkty4ninplgtzeychgz4yyrh"
                }
              ]
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "intolerant",
              "labelerDid": "did:plc:qkty4ninplgtzeychgz4yyrh",
              "visibility": "warn"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "bad-selfies",
              "labelerDid": "did:plc:skibpmllbhxvbvwgtjxl3uao",
              "visibility": "warn"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "cringe",
              "labelerDid": "did:plc:skibpmllbhxvbvwgtjxl3uao",
              "visibility": "warn"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "cryptid",
              "labelerDid": "did:plc:skibpmllbhxvbvwgtjxl3uao",
              "visibility": "warn"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "mutual-aid",
              "labelerDid": "did:plc:skibpmllbhxvbvwgtjxl3uao",
              "visibility": "warn"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "reposts-without-likes",
              "labelerDid": "did:plc:skibpmllbhxvbvwgtjxl3uao",
              "visibility": "warn"
          },
          {
              "$type": "app.bsky.actor.defs#contentLabelPref",
              "label": "watermarks",
              "labelerDid": "did:plc:skibpmllbhxvbvwgtjxl3uao",
              "visibility": "warn"
          }
        ]
    }
    """
    #expect(throws: Never.self) {
        _ = try! JSONDecoder().decode(
            app.bsky.actor.GetPreferences.Output.self,
            from: Data(input.utf8)
        )
    }
}
