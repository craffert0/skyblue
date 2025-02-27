enum SchemaError: Error {
    case invalidTypeName(name: String)
    case invalidDefinitionName(name: String)
}

func to_upper(_ s: some StringProtocol) -> String {
    s.first!.uppercased() + s.suffix(s.count - 1)
}

func to_lower(_ s: some StringProtocol) -> String {
    s.first!.lowercased() + s.suffix(s.count - 1)
}

class TypeDecoder: Decodable {
    let type: String
}

class Typename: Decodable {
    let json_name: String
    let full_name: String
    let namespace: String?
    let short_name: String

    required convenience init(from decoder: Decoder) throws {
        try self.init(decoder.singleValueContainer().decode(String.self))
    }

    init(_ name: String) throws {
        json_name = name
        let pieces = name.split(separator: "#", omittingEmptySubsequences: false)
        switch pieces.count {
        case 1:
            let full = name.split(separator: ".")
            namespace = full[0 ..< full.count - 1].joined(separator: ".")
            short_name = to_upper(full.last!)
            full_name = namespace! + "." + short_name
        case 2:
            short_name = to_upper(pieces[1])
            if pieces[0].count == 0 {
                namespace = nil
                full_name = short_name
            } else {
                namespace = String(pieces[0])
                full_name = namespace! + "." + short_name
            }
        default:
            throw SchemaError.invalidTypeName(name: name)
        }
    }

    func json_name(inNamespace ns: String) -> String {
        namespace == nil ? ns + json_name : json_name
    }

    func case_name(inNamespace ns: String) -> String {
        let fqcn = (namespace ?? ns) + "." + to_lower(short_name)
        return fqcn.replacingOccurrences(of: ".", with: "_")
    }
}
