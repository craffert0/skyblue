// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public protocol ApiFunctionBody: Codable {
    static var encoding: String { get }
}
