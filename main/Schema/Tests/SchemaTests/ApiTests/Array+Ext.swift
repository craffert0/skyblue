// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

extension Array {
    func removing(_ remove: (Self.Element) -> Bool) -> [Self.Element] {
        reduce([]) { a, e in
            if remove(e) {
                a
            } else {
                a + [e]
            }
        }
    }
}
