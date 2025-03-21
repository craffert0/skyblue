// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LoginView: View {
    @Bindable var login = SwiftDataService.shared.login
    @ObservedObject var controller: LoginController

    init(with controller: LoginController) {
        self.controller = controller
    }

    var body: some View {
        VStack {
            Form {
                TextField(text: $login.identifier,
                          prompt: Text("Username or email address"))
                {
                    Text("Username")
                }
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif
                .disableAutocorrection(true)
                .onSubmit { controller.login(login.input) }

                SecureField(text: $login.password,
                            prompt: Text("App password"))
                {
                    Text("Password")
                }
                .onSubmit { controller.login(login.input) }
            }
            Button("Login") { controller.login(login.input) }
        }
    }
}

#Preview {
    LoginView(with: LoginController())
}
