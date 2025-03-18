// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LoginView: View {
    @Bindable var login: Login
    @State var accessJwt: String?

    init(from login: Login) {
        self.login = login
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
            Text(accessJwt ?? "none")
            Button("Login") { loginNow() }
        }
    }

    func loginNow() {
        com.atproto.server.CreateSession.call(with: login.input) { result in
            DispatchQueue.main.async {
                switch result {
                case let .value(session):
                    accessJwt = session.accessJwt
                case let .http_error(error):
                    print(error)
                case let .error(error):
                    print(error)
                }
            }
        }.resume()
    }
}

#Preview {
    LoginView(from: Login())
}
