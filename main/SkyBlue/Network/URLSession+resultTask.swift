// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import SkyBlueApi

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
        switch Result<Output, Error>.from(data, response) {
        case let .success(output):
            return output
        case let .failure(error):
            throw error
        }
    }
}
