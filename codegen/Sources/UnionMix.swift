class UnionMix: Decodable {
    let refs: [Typename]
    let description: String?

    func emit(_ name: String, _ p: Printer) {
        p.println("public enum \(name): Codable {")
        p.indent()
        emit_cases(p)
        p.newline()
        emit_init(p)
        p.outdent()
        p.println("}")
    }

    private func emit_cases(_ p: Printer) {
        for t in refs {
            p.println("case \(t.case_name(inNamespace: p.namespace))(\(t.full_name))")
        }
        p.println("case unknown(String)")
    }

    private func emit_init(_ p: Printer) {
        p.println("public init(from decoder: Decoder) throws {")
        p.indent()

        p.println("let typename = try? decoder.singleValueContainer().decode(TypeName.self).typename")
        p.println("switch typename {")
        for t in refs {
            p.println("case \"\(t.json_name(inNamespace: p.namespace))\":")
            p.indent()
            p.println("self = try .\(t.case_name(inNamespace: p.namespace))(decoder.singleValueContainer().decode(\(t.full_name).self))")
            p.outdent()
        }
        p.println("default:")
        p.indent()
        p.println("self = .unknown(typename ?? \"??\")")
        p.outdent()
        p.println("}")

        p.outdent()
        p.println("}")
    }
}
