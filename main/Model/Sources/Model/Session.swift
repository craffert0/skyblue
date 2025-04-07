// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema

public class Session {
    public typealias CreateSession = com.atproto.server.CreateSession

    public let did: String
    public var accessJwt: String
    public var refreshJwt: String

    public init(from creds: CreateSession.Output) {
        did = creds.did
        accessJwt = creds.accessJwt
        refreshJwt = creds.refreshJwt
    }
}
