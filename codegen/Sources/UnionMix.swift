// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

class UnionMix: Decodable {
    let refs: [Typename]
    let description: String?

    func emit(_ name: String, _ p: Printer) {
        p.open("@frozen public enum \(name): Codable") {
            emit_cases(p)
            p.newline()
            emit_init(p)
        }
    }

    private func emit_cases(_ p: Printer) {
        for t in refs {
            p.println("case \(t.case_name)(\(t.full_name))")
        }
        p.println("case unknown(String)")
    }

    private func emit_init(_ p: Printer) {
        p.open("public init(from decoder: Decoder) throws") {
            p.println("let typename = try? decoder.singleValueContainer().decode(TypeName.self).typename")
            p.open("switch typename") {
                for t in refs {
                    p.println("case \"\(t.json_name(inNamespace: p.namespace))\":")
                    p.indent()
                    p.println("self = try .\(t.case_name)(decoder.singleValueContainer().decode(\(t.full_name).self))")
                    p.outdent()
                }
                p.println("default:")
                p.indent()
                p.println("self = .unknown(typename ?? \"??\")")
                p.outdent()
            }
        }
    }
}
