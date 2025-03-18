// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

struct HttpError {
    let statusCode: Int
    let body: Body

    struct Body: Codable {
        let error: String?
        let message: String?
    }
}
