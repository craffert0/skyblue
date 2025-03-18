// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var logins: [Login]

    /** Force `Login` to be a singleton. */
    var login: Login {
        if let first = logins.first {
            return first
        }
        let new = Login()
        modelContext.insert(new)
        return new
    }

    var body: some View {
        LoginView(from: login)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Login.self, inMemory: true)
}
