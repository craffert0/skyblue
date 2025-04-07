// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Model
import Observation
import Schema

@Observable class BlueskyService {
    public static let global = BlueskyService()

    typealias CreateSession = com.atproto.server.CreateSession
    typealias RefreshSession = com.atproto.server.RefreshSession

    public var status: Status = .loggedOut

    @MainActor
    func login(as identifier: String, with password: String) async {
        status = .loggingIn
        do {
            let input = CreateSession.Input(identifier: identifier,
                                            password: password)
            let session = try await CreateSession.call(with: input)
            status = .connected(Session(from: session))
        } catch {
            status = .failed(error)
        }
    }

    @MainActor
    func refresh() async {
        guard case let .connected(session) = status else {
            return
        }
        status = .loggingIn

        do {
            let session =
                try await RefreshSession.call(auth: session.refreshJwt)
            status = .connected(Session(from: session))
        } catch {
            status = .failed(error)
        }
    }
}
