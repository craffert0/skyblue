import Foundation
import Proto

private enum StringOrInt: Codable {
    case string(String)
    case int(Int)

    public init(from decoder: Decoder) throws {
        let svc = try decoder.singleValueContainer()
        do {
            self = try .string(svc.decode(String.self))
        } catch {
            self = try .int(svc.decode(Int.self))
        }
    }

    var string: String {
        switch self {
        case let .string(string):
            string
        case let .int(int):
            "\(int)"
        }
    }
}

extension Proto.Parameters {
    func queryItems() throws -> [URLQueryItem] {
        try JSONDecoder()
            .decode([String: StringOrInt].self,
                    from: JSONEncoder().encode(self))
            .map { URLQueryItem(name: $0.key, value: $0.value.string) }
    }
}
