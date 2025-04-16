// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import BlueSkyApi
import Foundation

extension Result where Success: ApiFunctionBody, Failure == any Error {
    static func from(_ data: Data?, _ response: URLResponse?,
                     _ error: (any Error)? = nil) -> Result
    {
        if let error {
            return .failure(error)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            return try! .failure(
                HttpError.http(
                    http_response.statusCode,
                    decoder.decode(HttpError.Body.self, from: data!),
                    http_response.allHeaderFields
                ))
        }
        do {
            return try .success(decoder.decode(Success.self, from: data!))
        } catch {
            return .failure(error)
        }
    }
}
