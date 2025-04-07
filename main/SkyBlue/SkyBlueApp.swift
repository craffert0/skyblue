// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import SwiftUI

@main
struct SkyBlueApp: App {
    let service = BlueskyService.global

    var body: some Scene {
        WindowGroup {
            ContentView(service: service)
        }
    }
}
