// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

@main
struct SkyBlueApp: App {
    var controller = LoginController()

    var body: some Scene {
        WindowGroup {
            ContentView(with: controller)
        }
    }
}
