import Foundation
import Schema

typealias Credentials = Schema.com.atproto.server.CreateSession.Input

extension Credentials {
    static func decode(from filePath: String) throws -> Credentials {
        try JSONDecoder().decode(
            Credentials.self,
            from: Data(contentsOf: URL(filePath: filePath))
        )
    }
}
