// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

@frozen public struct Blob: Codable {
    let ref: BlobRef
    let mimeType: String
    let size: Int
}

@frozen public struct BlobRef: Codable {
    let link: String

    enum CodingKeys: String, CodingKey {
        case link = "$link"
    }
}
