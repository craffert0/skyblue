// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

@main
struct SkyBlueApp: App {
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
