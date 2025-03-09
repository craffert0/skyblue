public protocol ApiProcedure00: ApiRequest {}

public protocol ApiProcedure01: ApiRequest {
    associatedtype Output
}

public protocol ApiProcedure10: ApiRequest {
    associatedtype Input
}

public protocol ApiProcedure11: ApiRequest {
    associatedtype Input
    associatedtype Output
}
