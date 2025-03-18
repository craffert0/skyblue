// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

enum Result<T: ApiFunctionBody> {
    case value(T)
    case error(Error)

    init(_ data: Data?, _ err: (any Error)?) {
        if let err {
            self = .error(err)
        } else {
            do {
                self = try .value(JSONDecoder().decode(T.self, from: data!))
            } catch {
                self = .error(error)
            }
        }
    }
}
