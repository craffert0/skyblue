// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Model
import SwiftData

// https://developer.apple.com/documentation/swiftdata/preserving-your-apps-model-data-across-launches

class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = SwiftDataService()

    @MainActor
    private init() {
        let schema = Schema([
            Login.self,
        ])
        let modelConfiguration =
            ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        modelContainer =
            try! ModelContainer(for: schema,
                                configurations: [modelConfiguration])
        modelContext = modelContainer.mainContext
    }

    var login: Login {
        // Force there to be a single Login
        let logins = try! modelContext.fetch(FetchDescriptor<Login>())
        if let first = logins.first {
            return first
        }
        let new = Login()
        modelContext.insert(new)
        return new
    }
}
