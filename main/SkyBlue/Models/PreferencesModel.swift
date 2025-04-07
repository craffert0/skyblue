// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Combine
import SwiftUI

class PreferencesModel: ObservableObject {
    public static let global = PreferencesModel()

    @AppStorage("settings.bsky.identifier") public var identifier: String = ""
    public var password: String {
        get {
            actual_password
        }
        set {
            actual_password = newValue
            _ = tryUpdate(password: newValue) || trySet(password: newValue)
        }
    }

    private var actual_password = PreferencesModel.loadPassword()

    private static let kBskyServer = "bsky.social"

    private static func loadPassword() -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: PreferencesModel.kBskyServer,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]

        // Get the item holding the credentials
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let actual = item as? [String: Any],
              let passwordData = actual[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: .utf8)
        else {
            return ""
        }
        return password
    }

    private func tryUpdate(password: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: PreferencesModel.kBskyServer,
        ]
        let attributes: [String: Any] = [
            kSecValueData as String: Data(password.utf8),
        ]
        return errSecSuccess == SecItemUpdate(query as CFDictionary,
                                              attributes as CFDictionary)
    }

    private func trySet(password: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: PreferencesModel.kBskyServer,
            kSecValueData as String: Data(password.utf8),
        ]

        return errSecSuccess == SecItemAdd(query as CFDictionary, nil)
    }
}
