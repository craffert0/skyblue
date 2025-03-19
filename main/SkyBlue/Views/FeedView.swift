// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct FeedView: View {
    @State var model: FeedModel

    init(from model: FeedModel) {
        self.model = model
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(model.feed) {
                    FeedViewPostView($0)
                }
            }
        }
    }
}
