import Foundation
import Proto
import RealHTTP

extension ApiQuery {
    static func query(
        auth: String,
        with params: Parameters? = nil
    ) async throws -> Response<Result> {
        let request = try HTTPRequest(method: .get,
                                      URL(forBsky: apiPath, with: params),
                                      auth: auth)
        let response = try await request.fetch()
        return try response.decodeResponse(Result.self)
    }
}
