// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

enum HttpError: Error {
    case http(Int, Body)

    struct Body: Codable {
        let error: String?
        let message: String?
    }
}
