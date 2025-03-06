import ArgumentParser
import Foundation
import Proto

@main
struct Main: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Get stuff from bsky server.",
        subcommands: [Author.self, Prefs.self, Timeline.self],
        defaultSubcommand: Prefs.self
    )

    struct Options: ParsableArguments {
        @Flag(name: [.long, .customShort("v")], help: "Be verbose.")
        var verbose = false

        @Argument(transform: Credentials.init(from:))
        var creds: Credentials

        func session() async throws -> Session? {
            try await Session(with: creds, verbose: verbose)
        }
    }

    struct Author: AsyncParsableCommand {
        static let configuration =
            CommandConfiguration(abstract: "Show the Author's feed.")

        @OptionGroup var options: Options

        mutating func run() async throws {
            try await options.session()?.getSelfAuthorFeed()?.dumpJson()
        }
    }

    struct Prefs: AsyncParsableCommand {
        static let configuration =
            CommandConfiguration(abstract: "Show the Author's prefs.")

        @OptionGroup var options: Options

        mutating func run() async throws {
            try await options.session()?.getPreferences()?.dumpJson()
        }
    }

    struct Timeline: AsyncParsableCommand {
        static let configuration =
            CommandConfiguration(abstract: "Show the timeline.")

        @OptionGroup var options: Options

        mutating func run() async throws {
            guard var session = try await options.session() else {
                return
            }
            try await session.getTimeline()?.dumpJson()
            try await session.getTimeline()?.dumpJson()
            try await session.refresh()
            try await session.getTimeline()?.dumpJson()
            try await session.getTimeline()?.dumpJson()
        }
    }
}
