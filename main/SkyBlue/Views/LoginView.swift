// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LoginView: View {
    @ObservedObject var controller: LoginController

    init(with controller: LoginController) {
        self.controller = controller
    }

    var body: some View {
        VStack {
            Form {
                TextField(text: $controller.login.identifier,
                          prompt: Text("Username or email address"))
                {
                    Text("Username")
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onSubmit { loginNow() }

                SecureField(text: $controller.login.password,
                            prompt: Text("App password"))
                {
                    Text("Password")
                }
                .onSubmit { loginNow() }
            }
            switch controller.status {
            case .loggedOut:
                Text("logged out")
            case .loggingIn:
                Text("logging in")
            case let .connected(session):
                Text(session.accessJwt)
            }
            Button("Login") { loginNow() }
        }
    }

    func loginNow() {
        controller.loginNow()
    }
}

#Preview {
    LoginView(with: LoginController())
}
