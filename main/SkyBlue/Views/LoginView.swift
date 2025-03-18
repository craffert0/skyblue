// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2013 Colin Rafferty <colin@rafferty.net>

import SwiftUI

struct LoginView: View {
    @Bindable var login: Login

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
            Button("Login") { loginNow() }
        }
    }

    func loginNow() {
        print("login [\(login.identifier)/\(login.password)]")
    }
}

#Preview {
    LoginView(from: Login())
}
