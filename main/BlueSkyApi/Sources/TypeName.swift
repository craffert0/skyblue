// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

// Each "unknown" object has a "$type" field and all the regular fields for
// that particular type. So the simplest solution is to define a `struct` with
// a single "$type" field, decode into that, and using the underlying name,
// decode again into the proper type. That's `AnyPet.init()`.

public struct TypeName: Codable {
    public let typename: String
    public enum CodingKeys: String, CodingKey {
        case typename = "$type"
    }
}
