import Foundation
import RealHTTP
import Schema

extension Schema.ApiQuery {
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
