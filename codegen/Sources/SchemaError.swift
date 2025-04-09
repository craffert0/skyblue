// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

enum SchemaError: Error {
    case invalidTypeName(name: String)
    case invalidDefinitionName(name: String)
}
