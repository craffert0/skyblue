// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LoginView: View {
    @Bindable var login: Login
    @State var status: Status

    init(from login: Login) {
        self.login = login
        status = .loggedOut
    }

    var body: some View {
        VStack {
            Form {
                TextField(text: $login.identifier,
                          prompt: Text("Username or email address"))
                {
                    Text("Username")
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onSubmit { loginNow() }

                SecureField(text: $login.password,
                            prompt: Text("App password"))
                {
                    Text("Password")
                }
                .onSubmit { loginNow() }
            }
            switch status {
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
        status = .loggingIn
        com.atproto.server.CreateSession.call(with: login.input) { result in
            DispatchQueue.main.async {
                switch result {
                case let .value(session):
                    status = .connected(Session(from: session))
                case let .http_error(error):
                    status = .loggedOut
                    print(error)
                case let .error(error):
                    status = .loggedOut
                    print(error)
                }
            }
        }.resume()
    }
}

#Preview {
    LoginView(from: Login())
}
