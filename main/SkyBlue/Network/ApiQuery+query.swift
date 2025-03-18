// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

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
        completed: @escaping @Sendable (Output) -> Void
    ) -> URLSessionDataTask {
        let request = request(auth: auth, with: params)
        return URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data else { return }
            do {
                let result = try JSONDecoder().decode(Output.self, from: data)
                DispatchQueue.main.async { completed(result) }
            } catch {
                print(error)
            }
        }
    }
}
