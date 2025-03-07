/// When we get a non-200
public struct ApiError: Codable {
    let error: String
    let message: String
}
