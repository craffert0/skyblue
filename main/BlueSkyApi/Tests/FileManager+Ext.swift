// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

import Foundation

enum FileManagerError: Error {
    case badfile
}

extension FileManager {
    func lines(ofSyntax name: String) throws -> [any StringProtocol] {
        let path =
            NSHomeDirectory() +
            "/src/atproto/interop-test-files/syntax/" +
            name
        guard let dataContents = contents(atPath: path),
              let contents = String(data: dataContents, encoding: .utf8)
        else {
            throw FileManagerError.badfile
        }
        return contents.split(separator: "\n").removing {
            $0.count == 0 || $0.first == "#"
        }
    }
}
