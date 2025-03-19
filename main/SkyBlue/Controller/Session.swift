// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Schema

class Session {
    typealias CreateSession = com.atproto.server.CreateSession

    let did: String
    var accessJwt: String
    var refreshJwt: String

    init(from creds: CreateSession.Output) {
        did = creds.did
        accessJwt = creds.accessJwt
        refreshJwt = creds.refreshJwt

        print(creds)
    }
}
