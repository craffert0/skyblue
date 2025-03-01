import Foundation

if CommandLine.arguments.count >= 2 {
    let t = Task {
        if var session = try await Session(with: Credentials(from: CommandLine.arguments[1])) {
            if CommandLine.arguments.count == 3 {
                try await session.printSelfAuthorFeed()
            } else if CommandLine.arguments.count == 4 {
                try await session.printPreferences()
            } else {
                try await session.printTimeline()
                try await session.printTimeline()
                try await session.refresh()
                try await session.printTimeline()
                try await session.printTimeline()
            }
        } else {
            print("oops!")
        }
    }

    try await t.value
} else {
    print("usage: swift run top10 ~/.skybluerc")
}
