// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

public protocol ApiQuery: ApiRequest {
    associatedtype Parameters: ApiParameters
    associatedtype Output: ApiFunctionBody
}
