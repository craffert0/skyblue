import Foundation

public enum Nullable<T: Codable>: Codable {
    case null
    case value(T)

    public init(from decoder: any Decoder) throws {
        let svc = try decoder.singleValueContainer()
        if svc.decodeNil() {
            self = .null
        } else {
            self = try .value(svc.decode(T.self))
        }
    }
}
