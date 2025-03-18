public protocol ApiSubscription: ApiRequest {
    associatedtype Parameters
    associatedtype Message
}
