import Foundation
import Schema

extension URL {
    init(forBsky path: String) {
        self.init(string: "https://bsky.social/xrpc/\(path)")!
    }

    init(forBsky path: String, with params: (some Schema.ApiParameters)?) throws {
        self.init(forBsky: path)
        if let params {
            try append(queryItems: params.queryItems())
        }
    }
}
