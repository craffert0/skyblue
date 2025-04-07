// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Schema
import SwiftUI

struct LoginView: View {
    @ObservedObject var preferences = PreferencesModel.global
    var password: Binding<String> {
        Binding {
            preferences.password
        } set: {
            preferences.password = $0
        }
    }

    var service: BlueskyService
    @State var error: LoginError?
    @State var showsError = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(text: preferences.$identifier,
                              prompt: Text("Username or email address"))
                    {
                        Text("Username")
                    }
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .disableAutocorrection(true)
                    .onSubmit { login() }

                    SecureField(text: password,
                                prompt: Text("App password"))
                    {
                        Text("Password")
                    }
                    .onSubmit { login() }
                } header: {
                    Text("Account")
                }
            }.navigationTitle("BlueSky Login")
            Button("Login") { login() }
        }
        .alert(isPresented: $showsError, error: error) {}
    }

    func login() {
        Task {
            await service.login(as: preferences.identifier,
                                with: preferences.password)
            DispatchQueue.main.async {
                if case let .failed(error) = service.status {
                    self.error = error as? LoginError ?? .otherError(error: error)
                    showsError = true
                }
            }
        }
    }
}

#Preview {
    LoginView(service: BlueskyService())
}
