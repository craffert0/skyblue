// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension Result where Success: ApiFunctionBody, Failure == any Error {
    static func from(_ data: Data?, _ response: URLResponse?,
                     _ error: (any Error)?) -> Result
    {
        if let error {
            return .failure(error)
        }
        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            return try! .failure(
                HttpError.http(
                    http_response.statusCode,
                    JSONDecoder().decode(HttpError.Body.self, from: data!)
                ))
        }
        do {
            let d = JSONDecoder()
            d.dateDecodingStrategy = .iso8601WithFractionalSeconds
            return try .success(d.decode(Success.self, from: data!))
        } catch {
            return .failure(error)
        }
    }
}
