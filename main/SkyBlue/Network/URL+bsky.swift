// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import BlueSkyApi
import Foundation

extension URL {
    init(forBsky path: String) {
        self.init(string: "https://bsky.social/xrpc/\(path)")!
    }

    init(forBsky path: String,
         with params: (some ApiParameters)?) throws
    {
        self.init(forBsky: path)
        if let params {
            try append(queryItems: params.queryItems())
        }
    }
}
