// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Model
import Testing

@Suite struct LoginTests {
    @Test func testConvenience() {
        let actual = Login()
        #expect(actual.identifier == "")
        #expect(actual.password == "")
    }
}
