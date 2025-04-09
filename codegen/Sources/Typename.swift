// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

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
            short_name = full.last!.upper
            full_name = namespace! + "." + short_name
        case 2:
            short_name = pieces[1].upper
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

    var case_name: String {
        if let namespace {
            (namespace + "." + short_name.lower)
                .replacingOccurrences(of: ".", with: "_")
        } else {
            short_name.lower
        }
    }
}
