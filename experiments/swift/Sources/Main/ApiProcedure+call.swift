// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import BlueSkyApi
import Foundation
import RealHTTP

extension ApiProcedure11 {
    static func call(
        with input: Input, auth: String? = nil
    ) async throws -> Response<Output> {
        let request = try HTTPRequest(method: .post,
                                      URL(forBsky: apiPath),
                                      auth: auth,
                                      body: input)
        let response = try await request.fetch()
        return try response.decodeResponse(Output.self)
    }
}

extension ApiProcedure01 {
    static func call(auth: String? = nil) async throws -> Response<Output> {
        let request = try HTTPRequest(method: .post,
                                      URL(forBsky: apiPath),
                                      auth: auth)
        let response = try await request.fetch()
        return try response.decodeResponse(Output.self)
    }
}
