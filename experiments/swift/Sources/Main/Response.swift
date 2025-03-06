import Proto
import RealHTTP

extension HTTPStatusCode: @retroactive Encodable {}

enum Response<Type: Encodable>: Encodable {
    case value(Type)
    case error(HTTPStatusCode, Proto.HttpError)
}

extension HTTPResponse {
    func decodeResponse<T>(_ type: T.Type) throws -> Response<T> where T: Decodable {
        switch statusCode {
        case .ok:
            try .value(decode(type))
        default:
            try .error(statusCode, decode(Proto.HttpError.self))
        }
    }
}
