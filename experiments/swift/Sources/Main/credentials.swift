import Foundation
import Proto

typealias Credentials = Proto.com.atproto.server.CreateSession.Input

func credentials_decode(from filePath: String) throws -> Credentials {
    try JSONDecoder().decode(
        Credentials.self,
        from: Data(contentsOf: URL(filePath: filePath))
    )
}
