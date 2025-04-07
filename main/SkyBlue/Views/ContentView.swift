// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Model
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var service: BlueskyService

    var body: some View {
        if case let .connected(session) = service.status {
            FeedView(session: session)
        } else {
            LoginView(service: service)
        }
    }
}

#Preview {
    ContentView(service: BlueskyService())
}
