// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

@main
struct SkyBlueApp: App {
    var controller = LoginController()

    // TODO: This seems excessive. Why not direct?
    // https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches
    // Or maybe Login is really `Foundation.UserDefaults`
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Login.self,
        ])
        let modelConfiguration =
            ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema,
                                      configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(with: controller)
        }
        .modelContainer(sharedModelContainer)
    }
}
