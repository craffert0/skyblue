/// When we get a non-200
public struct HttpError: Codable {
    let error: String
    let message: String
}
