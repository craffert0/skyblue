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
}
