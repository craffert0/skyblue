import Foundation

struct Credentials: Codable {
    let identifier: String
    let password: String

    init(from filePath: String) throws {
        self = try JSONDecoder().decode(
            Credentials.self,
            from: Data(contentsOf: URL(filePath: filePath))
        )
    }
}
