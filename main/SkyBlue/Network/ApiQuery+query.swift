// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension Schema.ApiQuery {
    static func request(auth: String,
                        with params: Parameters? = nil) -> URLRequest
    {
        try! URLRequest(method: "GET",
                        URL(forBsky: apiPath, with: params),
                        auth: auth)
    }

    static func query(
        auth: String, with params: Parameters? = nil,
        on q: DispatchQueue,
        completed: @escaping @Sendable (Result<Output, Error>) -> Void
    ) -> URLSessionDataTask {
        let request = request(auth: auth, with: params)
        return URLSession.shared.resultTask(with: request, on: q,
                                            completed: completed)
    }
}
