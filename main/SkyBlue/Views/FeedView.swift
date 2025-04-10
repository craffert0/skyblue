// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Model
import Schema
import SwiftUI

struct FeedView: View {
    var controller = TimelineController.global
    var session: Session

    var body: some View {
        ZStack(alignment: .center) {
            ScrollView(.vertical) {
                LazyVStack {
                    ForEach(controller.feed) { p in
                        FeedViewPostView(p)
                            .onAppear {
                                controller.loadMoreIfNeeded(currentPost: p)
                            }
                    }
                }
            }
            if controller.isLoading {
                ProgressView()
            } else if let errorMessage = controller.errorMessage {
                Label(errorMessage, systemImage: "snow")
                    .border(Color.red)
            }
        }
        .task {
            controller.loadInitialTimeline(with: session)
        }
    }
}
