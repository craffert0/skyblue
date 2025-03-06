import Foundation
import Proto

typealias Credentials = Proto.com.atproto.server.CreateSession.Input

extension Credentials {
    init(from filePath: String) throws {
        self = try JSONDecoder().decode(
            Credentials.self,
            from: Data(contentsOf: URL(filePath: filePath))
        )
    }
}
