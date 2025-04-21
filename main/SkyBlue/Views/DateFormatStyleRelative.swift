// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct DateFormatStyleRelative {
    typealias FormatInput = Date
    typealias FormatOutput = String

    let baseDate: Date

    init(to: Date) {
        baseDate = to
    }
}

extension DateFormatStyleRelative: FormatStyle {
    func format(_ value: Date) -> String {
        let seconds = Int(baseDate.distance(to: value))
        switch seconds {
        case 0 ..< 60: return "\(seconds)s"
        case 60 ..< 3600: return "\(seconds / 60)m"
        case 3600 ..< Int(baseDate.yesterday.distance(to: baseDate)):
            return "\(seconds / 3600)h"
        case 86400 ..< (7 * 86400):
            return value.formatted(Date.FormatStyle().weekday(.short))
        case 86400 ..< (30 * 86400):
            return "\(seconds / 86400)d"
        default:
            return "\(seconds / (30 * 86400))mo"
        }
    }
}

extension DateFormatStyleRelative: DiscreteFormatStyle {
    func discreteInput(before input: Date) -> Date? {
        Calendar.current.date(byAdding: .second,
                              value: -1, to: input)
    }

    func discreteInput(after input: Date) -> Date? {
        switch Int(baseDate.distance(to: input)) {
        case 0 ..< 60:
            Calendar.current.date(byAdding: .second,
                                  value: 1, to: input)
        case 60 ..< 3600:
            Calendar.current.date(byAdding: .minute,
                                  value: 1, to: input)
        case 3600 ..< 86400:
            Calendar.current.date(byAdding: .hour,
                                  value: 1, to: input)
        default:
            Calendar.current.date(byAdding: .day,
                                  value: 1, to: input)
        }
    }
}
