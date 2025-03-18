public protocol ApiQuery: ApiRequest {
    associatedtype Parameters: ApiParameters
    associatedtype Output: ApiFunctionBody
}
