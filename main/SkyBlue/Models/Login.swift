// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftData

@Model
public class Login {
    var identifier: String
    var password: String

    var input: com.atproto.server.CreateSession.Input {
        com.atproto.server.CreateSession.Input(identifier: identifier,
                                               password: password)
    }

    init(identifier: String, password: String) {
        self.identifier = identifier
        self.password = password
    }

    convenience init() {
        self.init(identifier: "", password: "")
    }
}
