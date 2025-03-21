// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension URLRequest {
    init(method: String, _ url: URL, auth: String? = nil) throws {
        self.init(url: url)
        httpMethod = method
        if let auth {
            setValue("Bearer " + auth, forHTTPHeaderField: "Authorization")
        }
    }

    init<Body: Schema.ApiFunctionBody>(method: String, _ url: URL, body: Body,
                                       auth: String? = nil) throws
    {
        try self.init(method: method, url, auth: auth)
        setValue(Body.encoding, forHTTPHeaderField: "Content-Type")
        try httpBody = JSONEncoder().encode(body)
    }
}
