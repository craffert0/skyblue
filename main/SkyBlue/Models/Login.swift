// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import SwiftData

@Model
public class Login {
    var identifier: String
    var password: String

    init(identifier: String, password: String) {
        self.identifier = identifier
        self.password = password
    }

    convenience init() {
        self.init(identifier: "", password: "")
    }
}
