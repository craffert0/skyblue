// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension URLSession {
    func resultTask<Output: ApiFunctionBody>(
        with request: URLRequest,
        completed: @escaping @Sendable (Result<Output, Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: request) { data, response, error in
            completed(Result<Output, Error>.from(data, response, error))
        }
    }
}
