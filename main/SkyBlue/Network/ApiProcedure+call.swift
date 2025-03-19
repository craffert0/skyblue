// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema

extension Schema.ApiProcedure11 {
    static func request(with input: Input,
                        auth: String? = nil) -> URLRequest
    {
        try! URLRequest(method: "POST",
                        URL(forBsky: apiPath),
                        body: input, auth: auth)
    }

    static func call(
        with input: Input, auth: String? = nil,
        completed: @escaping @Sendable (Result<Output, Error>) -> Void
    ) -> URLSessionDataTask {
        let request = request(with: input, auth: auth)
        return URLSession.shared.resultTask(with: request,
                                            completed: completed)
    }
}

extension Schema.ApiProcedure01 {
    static func request(auth: String? = nil) -> URLRequest {
        try! URLRequest(method: "POST",
                        URL(forBsky: apiPath),
                        auth: auth)
    }

    static func call(
        auth: String? = nil,
        completed: @escaping @Sendable (Result<Output, Error>) -> Void
    ) -> URLSessionDataTask {
        let request = request(auth: auth)
        return URLSession.shared.resultTask(with: request,
                                            completed: completed)
    }
}
