// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct FeedView: View {
    @ObservedObject var controller: TimelineController

    init(from controller: TimelineController) {
        self.controller = controller
    }

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack {
                    ForEach(controller.feed) {
                        FeedViewPostView($0)
                    }
                }
            }
            Button("More") { controller.more() }
        }
    }
}
