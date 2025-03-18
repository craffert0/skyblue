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
        completed: @escaping @Sendable (Output) -> Void
    ) -> URLSessionDataTask {
        let request = request(with: input, auth: auth)
        return URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data else { return }
            do {
                let output = try JSONDecoder().decode(Output.self, from: data)
                DispatchQueue.main.async { completed(output) }
            } catch {
                print(error)
            }
        }
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
        completed: @escaping @Sendable (Output) -> Void
    ) -> URLSessionDataTask {
        let request = request(auth: auth)
        return URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data else { return }
            do {
                let output = try JSONDecoder().decode(Output.self, from: data)
                completed(output)
            } catch {
                print(error)
            }
        }
    }
}
