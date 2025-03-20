// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

class TimelineController: ObservableObject {
    typealias FeedViewPost = app.bsky.feed.defs.FeedViewPost
    private typealias GetTimeline = app.bsky.feed.GetTimeline

    @Published var feed: [FeedViewPost] = []
    private var session: Session?
    private var cursor: String?

    func loadInitialTimeline(with session: Session) {
        self.session = session
        load()
    }

    func more() { load() }

    private func load() {
        guard let session else { return }
        print(cursor ?? "none")
        let params = GetTimeline.Parameters(cursor: cursor, limit: 10)
        GetTimeline.query(auth: session.accessJwt, with: params,
                          on: DispatchQueue.main)
        { [weak self] r in
            switch r {
            case let .success(result):
                self?.feed.append(contentsOf: result.feed)
                self?.cursor = result.cursor
            case let .failure(error):
                print(error)
            }
        }.resume()
    }
}
