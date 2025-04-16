// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import RealHTTP
import SkyBlueApi

extension SkyBlueApi.ApiQuery {
    static func query(
        auth: String,
        with params: Parameters? = nil
    ) async throws -> Response<Output> {
        let request = try HTTPRequest(method: .get,
                                      URL(forBsky: apiPath, with: params),
                                      auth: auth)
        let response = try await request.fetch()
        return try response.decodeResponse(Output.self)
    }
}
