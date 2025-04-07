import Foundation
import RealHTTP
import Schema

extension HTTPStatusCode: @retroactive Encodable {}

enum Response<Type: Encodable>: Encodable {
    case value(Type)
    case error(HTTPStatusCode, Schema.ApiError)
}

extension HTTPResponse {
    func decodeResponse<T>(_ type: T.Type) throws -> Response<T> where T: Decodable {
        switch statusCode {
        case .ok:
            let d = JSONDecoder()
            d.dateDecodingStrategy = .iso8601WithFractionalSeconds
            return try .value(d.decode(type, from: data ?? Data()))
        default:
            return try .error(statusCode, decode(Schema.ApiError.self))
        }
    }
}
