public protocol ApiProcedure00: ApiRequest {}

public protocol ApiProcedure01: ApiRequest {
    associatedtype Output: ApiOutput
}

public protocol ApiProcedure10: ApiRequest {
    associatedtype Input: ApiInput
}

public protocol ApiProcedure11: ApiRequest {
    associatedtype Input: ApiInput
    associatedtype Output: ApiOutput
}
