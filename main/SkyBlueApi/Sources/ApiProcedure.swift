// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

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
