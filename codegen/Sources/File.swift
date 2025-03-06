import Foundation

class File: Decodable {
    let id: String
    let defs: [String: Definition]

    func emit() -> Data {
        let p = Printer(inNamespace: id)
        let namespace = id.split(separator: ".")
        let last = namespace.last!
        let ext = namespace[0 ..< namespace.count - 1].joined(separator: ".")
        p.println("extension \(ext) {")
        p.indent()

        if defs["main"] != nil {
            p.println("public typealias \(to_upper(last)) = \(last).Main")
            p.newline()
        }

        p.println("public enum \(last) {")
        p.indent()
        for k in defs.keys.sorted() {
            defs[k]?.emit(k, p)
            p.newline()
        }
        p.outdent()
        p.println("}")
        p.outdent()
        p.println("}")
        return p.data
    }
}
