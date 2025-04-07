// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Model
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    var controller: LoginController

    init(with controller: LoginController) {
        self.controller = controller
    }

    var body: some View {
        switch controller.status {
        case .loggedOut, .loggingIn:
            LoginView(with: controller)
        case .connected:
            FeedView(from: controller.timeline)
        }
    }
}

#Preview {
    ContentView(with: LoginController())
        .modelContainer(for: Login.self, inMemory: true)
}
