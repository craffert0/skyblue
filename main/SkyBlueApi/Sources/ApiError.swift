// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

/// When we get a non-200
public struct ApiError: Codable {
    let error: String
    let message: String
}
