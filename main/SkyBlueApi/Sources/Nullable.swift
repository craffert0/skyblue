// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

@frozen public enum Nullable<T: Codable & Sendable>: Codable {
    case null
    case value(T)

    public init(from decoder: any Decoder) throws {
        let svc = try decoder.singleValueContainer()
        if svc.decodeNil() {
            self = .null
        } else {
            self = try .value(svc.decode(T.self))
        }
    }
}
