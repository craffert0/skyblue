// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import SkyBlueApi

extension URLRequest {
    init(method: String, _ url: URL, auth: String? = nil) throws {
        self.init(url: url)
        httpMethod = method
        if let auth {
            setValue("Bearer " + auth, forHTTPHeaderField: "Authorization")
        }
    }

    init<Body: ApiFunctionBody>(method: String, _ url: URL, body: Body,
                                auth: String? = nil) throws
    {
        try self.init(method: method, url, auth: auth)
        setValue(Body.encoding, forHTTPHeaderField: "Content-Type")
        try httpBody = JSONEncoder().encode(body)
    }
}
