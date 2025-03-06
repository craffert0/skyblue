import ArgumentParser
import Foundation
import Proto

@main
struct Main: AsyncParsableCommand {
    @Argument(transform: Credentials.init(from:))
    var creds: Credentials
    @Argument
    var option = 1

    mutating func run() async throws {
        guard var session = try await Session(with: creds) else {
            print("no session")
            return
        }

        switch option {
        case 1:
            try await session.getSelfAuthorFeed()?.dumpJson()
        case 2:
            try await session.getPreferences()?.dumpJson()
        case 3:
            try await session.getTimeline()?.dumpJson()
            try await session.getTimeline()?.dumpJson()
            try await session.refresh()
            try await session.getTimeline()?.dumpJson()
            try await session.getTimeline()?.dumpJson()
        default:
            print("oops")
        }
    }
}
