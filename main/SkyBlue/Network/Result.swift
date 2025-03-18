// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

enum Result<T: ApiFunctionBody> {
    case value(T)
    case http_error(HttpError)
    case error(Error)
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601WithFractionalSeconds = custom { d in
        let raw = try d.singleValueContainer().decode(String.self)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =
            [.withInternetDateTime, .withFractionalSeconds]
        guard let date = formatter.date(from: raw) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: d.codingPath,
                                      debugDescription: raw))
        }
        return date
    }
}

extension Result {
    static func from(_ data: Data?, _ response: URLResponse?,
                     _ err: (any Error)?) -> Result
    {
        if let err {
            return .error(err)
        }
        let http_response = response as! HTTPURLResponse
        guard http_response.statusCode == 200 else {
            return try! .http_error(
                HttpError(
                    statusCode: http_response.statusCode,
                    body: JSONDecoder().decode(HttpError.Body.self, from: data!)
                ))
        }
        do {
            let d = JSONDecoder()
            d.dateDecodingStrategy = .iso8601WithFractionalSeconds
            return try .value(d.decode(T.self, from: data!))
        } catch {
            return .error(error)
        }
    }
}
