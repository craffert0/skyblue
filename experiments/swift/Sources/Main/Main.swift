import ArgumentParser
import Foundation

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
            try await session.printSelfAuthorFeed()
        case 2:
            try await session.printPreferences()
        case 3:
            try await session.printTimeline()
            try await session.printTimeline()
            try await session.refresh()
            try await session.printTimeline()
            try await session.printTimeline()
        default:
            print("oops")
        }
    }
}
