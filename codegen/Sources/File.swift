// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

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
        p.println("import BlueSkyApi")
        p.newline()

        let ext = namespace.joined(separator: ".")
        p.open("extension \(ext)") {
            if defs["main"] != nil {
                p.println("public typealias \(name.upper) = \(name).Main")
                p.newline()
            }

            p.open("@frozen public enum \(name)") {
                for k in defs.keys.sorted() {
                    defs[k]?.emit(k, p)
                    p.newline()
                }
            }
        }
        return p.data
    }
}
