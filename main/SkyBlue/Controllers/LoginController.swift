// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation
import Schema
import SwiftUI

class LoginController: ObservableObject {
    @Published var status: Status = .loggedOut
    // TODO: This should be a @Query, but also needs to be bindable. Maybe:
    // https://medium.com/@dikidwid0/implement-swiftdata-in-swiftui-using-mvvm-architecture-pattern-aa3a9973c87c
    @Bindable var login = Login()
    var timeline = TimelineController()

    func loginNow() {
        status = .loggingIn
        com.atproto.server.CreateSession.call(with: login.input,
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
