// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Testing

struct Wrapper: Codable {
    let date: Date
}

@Suite struct JSONDecoder_DateDecodingStrategyTest {
    func parse(_ s: String) throws -> Date {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601WithFractionalSeconds
        return try d.decode(Wrapper.self,
                            from: Data("{\"date\": \"\(s)\"}".utf8))
            .date
    }

    func milli(_ s: String) -> Date {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return f.date(from: s)!
    }

    func second(_ s: String) -> Date {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return f.date(from: s)!
    }

    @Test func milliTest() throws {
        let dates = [
            "2025-03-05T16:04:34.025Z",
            "2025-03-20T15:58:42.133+00:00",
            "2025-03-20T15:58:42.133+0500",
        ]
        for d in dates {
            #expect(try parse(d) == milli(d))
        }
    }

    @Test func badTest() throws {
        let dates = [
            "2025-03-05T16:04:34Z",
            "2025-03-20T15:58:42+00:00",
        ]
        for d in dates {
            #expect(try parse(d) == second(d))
        }
    }
}
