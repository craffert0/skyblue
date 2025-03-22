// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct FeedView: View {
    var controller: TimelineController

    init(from controller: TimelineController) {
        self.controller = controller
    }

    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(controller.feed) {
                            FeedViewPostView($0)
                        }
                    }
                }
                Button("More") { controller.more() }
            }
            if controller.isLoading {
                ProgressView()
            } else if let errorMessage = controller.errorMessage {
                Label(errorMessage, systemImage: "snow")
                    .border(Color.red)
            }
        }
    }
}
