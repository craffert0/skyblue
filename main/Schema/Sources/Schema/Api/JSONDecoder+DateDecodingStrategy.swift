// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

public extension JSONDecoder.DateDecodingStrategy {
    static let iso8601WithFractionalSeconds = custom { d in
        let raw = try d.singleValueContainer().decode(String.self)
        let formatter = ISO8601DateFormatter()

        // They mostly have milliseconds.
        formatter.formatOptions =
            [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: raw) {
            return date
        }

        // But some of them don't!
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: raw) {
            return date
        }

        // Oh well.
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: d.codingPath,
                                  debugDescription: raw))
    }
}
