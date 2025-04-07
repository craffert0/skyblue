// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData

@Model
public class Login {
    public var identifier: String
    public var password: String

    public var input: com.atproto.server.CreateSession.Input {
        com.atproto.server.CreateSession.Input(identifier: identifier,
                                               password: password)
    }

    public init(identifier: String, password: String) {
        self.identifier = identifier
        self.password = password
    }

    convenience public init() {
        self.init(identifier: "", password: "")
    }
}
