// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

extension StringProtocol {
    var upper: String {
        first!.uppercased() + suffix(count - 1)
    }

    var lower: String {
        first!.lowercased() + suffix(count - 1)
    }
}
