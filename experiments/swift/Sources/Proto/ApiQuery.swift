public protocol ApiQuery: ApiRequest {
    associatedtype Parameters: ApiParameters
    associatedtype Result: Codable
}
