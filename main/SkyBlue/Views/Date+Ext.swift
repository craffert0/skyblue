// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension Date {
    var yesterday: Date {
        Calendar.current.startOfDay(
            for: Calendar.current.date(byAdding: .day,
                                       value: -1, to: self)!)
    }
}
