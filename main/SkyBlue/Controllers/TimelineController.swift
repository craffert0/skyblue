// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Combine
import Dispatch
import Model
import Observation
import Schema

@Observable class TimelineController {
    static var global = TimelineController()

    typealias FeedViewPost = app.bsky.feed.defs.FeedViewPost
    private typealias GetTimeline = app.bsky.feed.GetTimeline

    var feed: [FeedViewPost] = []
    var isLoading: Bool = false
    var errorMessage: String?

    private var session: Session?
    private var cursor: String?

    // TODO: these should all be @MainActor & async
    func loadInitialTimeline(with session: Session) {
        self.session = session
        load()
    }

    func more() { load() }

    private func load() {
        guard let session else { return }
        isLoading = true
        errorMessage = nil

        let params = GetTimeline.Parameters(cursor: cursor, limit: 10)
        GetTimeline.query(auth: session.accessJwt, with: params,
                          on: DispatchQueue.main)
        { [weak self] r in
            self?.isLoading = false
            switch r {
            case let .success(result):
                self?.feed.append(contentsOf: result.feed)
                self?.cursor = result.cursor
            case let .failure(error):
                self?.errorMessage = error.localizedDescription
                print(error)
            }
        }.resume()
    }
}
