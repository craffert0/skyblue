// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import SwiftUI

class LoginController: ObservableObject {
    typealias CreateSession = com.atproto.server.CreateSession

    @Published var status: Status = .loggedOut
    // https://medium.com/@dikidwid0/implement-swiftdata-in-swiftui-using-mvvm-architecture-pattern-aa3a9973c87c
    var timeline = TimelineController()

    func login(_ input: CreateSession.Input) {
        status = .loggingIn
        com.atproto.server.CreateSession.call(with: input,
                                              on: DispatchQueue.main)
        {
            [weak self] result in
            switch result {
            case let .success(session):
                let session = Session(from: session)
                self?.status = .connected(session)
                self?.timeline.loadInitialTimeline(with: session)
            case let .failure(error):
                self?.status = .loggedOut
                print(error)
            }
        }.resume()
    }
}
