// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

enum LoginError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
    case otherError(error: Error)
}

extension LoginError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noPassword: "no password"
        case .unexpectedPasswordData: "unusual password"
        case let .unhandledError(status): "\(status)"
        case let .otherError(e): "other \(e)"
        }
    }
}
