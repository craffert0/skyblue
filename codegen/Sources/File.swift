import Foundation

class File: Decodable {
    let id: String
    let defs: [String: Definition]

    var namespace: [String] {
        let n = id.split(separator: ".")
        return n[0 ..< n.count - 1].map { String($0) }
    }

    var name: String {
        String(id.split(separator: ".").last!)
    }

    func emit() -> Data {
        let p = Printer(inNamespace: id)
        p.println("import Foundation")
        p.newline()

        let ext = namespace.joined(separator: ".")
        p.open("extension \(ext)") {
            if defs["main"] != nil {
                p.println("public typealias \(to_upper(name)) = \(name).Main")
                p.newline()
            }

            p.open("public enum \(name)") {
                for k in defs.keys.sorted() {
                    defs[k]?.emit(k, p)
                    p.newline()
                }
            }
        }
        return p.data
    }
}
