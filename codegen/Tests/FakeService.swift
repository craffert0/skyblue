// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

struct FakeService {
    func get<Output: Decodable>(name: String) throws -> Output {
        let path = Bundle.module.url(forResource: name,
                                     withExtension: "json")!
        let json = try Data(contentsOf: path)
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601WithFractionalSeconds
        return try d.decode(Output.self, from: json)
    }
}
