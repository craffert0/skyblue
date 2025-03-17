public protocol ApiProcedure00: ApiRequest {}

public protocol ApiProcedure01: ApiRequest {
    associatedtype Output: ApiFunctionBody
}

public protocol ApiProcedure10: ApiRequest {
    associatedtype Input: ApiFunctionBody
}

public protocol ApiProcedure11: ApiRequest {
    associatedtype Input: ApiFunctionBody
    associatedtype Output: ApiFunctionBody
}
