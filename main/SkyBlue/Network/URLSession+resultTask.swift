// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension URLSession {
    func resultTask<Output: ApiFunctionBody>(
        with request: URLRequest,
        on q: DispatchQueue,
        completed: @escaping @Sendable (Result<Output, Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: request) { data, response, error in
            q.async {
                completed(Result<Output, Error>.from(data, response, error))
            }
        }
    }

    func output<Output: ApiFunctionBody>(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)? = nil
    ) async throws -> Output {
        let (data, response) =
            try await data(for: request, delegate: delegate)
        let http_response = response as! HTTPURLResponse
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601WithFractionalSeconds
        guard http_response.statusCode == 200 else {
            let body = try d.decode(HttpError.Body.self, from: data)
            throw HttpError.http(http_response.statusCode, body,
                                 http_response.allHeaderFields)
        }
        return try d.decode(Output.self, from: data)
    }
}
