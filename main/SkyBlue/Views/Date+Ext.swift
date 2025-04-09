// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

extension Date {
    var eBirdFormat: FormatStyle {
        FormatStyle()
            .month(.abbreviated)
            .day(.defaultDigits)
            .hour(.conversationalDefaultDigits(amPM: .abbreviated))
            .minute()
    }

    var eBirdFormatted: String {
        formatted(eBirdFormat)
    }

    var yesterday: Date {
        Calendar.current.startOfDay(
            for: Calendar.current.date(byAdding: .day,
                                       value: -1, to: self)!)
    }

    func relative(to other: Date = Date.now) -> String {
        let seconds = Int(distance(to: other))
        switch seconds {
        case 0 ..< 60: return "\(seconds)s"
        case 60 ..< 3600: return "\(seconds / 60)m"
        case 3600 ..< Int(other.yesterday.distance(to: other)):
            return "\(seconds / 3600)h"
        case (86400 * 366) ... Int.max:
            return "!!"
        default:
            return formatted(FormatStyle().weekday(.short))
        }
    }
}
