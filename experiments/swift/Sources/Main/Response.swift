import Foundation
import Proto
import RealHTTP

extension HTTPStatusCode: @retroactive Encodable {}

enum Response<Type: Encodable>: Encodable {
    case value(Type)
    case error(HTTPStatusCode, Proto.ApiError)
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601WithFractionalSeconds = custom { decoder in
        let dateStr = try decoder.singleValueContainer().decode(String.self)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions =
            [.withInternetDateTime, .withFractionalSeconds]
        guard let date = formatter.date(from: dateStr) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: dateStr))
        }
        return date
    }
}

extension HTTPResponse {
    func decodeResponse<T>(_ type: T.Type) throws -> Response<T> where T: Decodable {
        switch statusCode {
        case .ok:
            let d = JSONDecoder()
            d.dateDecodingStrategy = .iso8601WithFractionalSeconds
            return try .value(d.decode(type, from: data ?? Data()))
        default:
            return try .error(statusCode, decode(Proto.ApiError.self))
        }
    }
}
