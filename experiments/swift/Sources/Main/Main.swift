import ArgumentParser
import Foundation
import Schema

typealias GetAuthorFeed = Schema.app.bsky.feed.GetAuthorFeed
typealias GetPreferences = Schema.app.bsky.actor.GetPreferences
typealias GetTimeline = Schema.app.bsky.feed.GetTimeline
typealias CreateSession = Schema.com.atproto.server.CreateSession
typealias RefreshSession = Schema.com.atproto.server.RefreshSession

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

        @Argument(transform: Credentials.decode(from:))
        var creds: Credentials

        func login() async throws -> CreateSession.Output? {
            switch try await CreateSession.call(with: creds) {
            case let .value(login):
                return login
            case let .error(code, error):
                print(code, error)
                return nil
            }
        }
    }

    struct Author: AsyncParsableCommand {
        static let configuration =
            CommandConfiguration(abstract: "Show the Author's feed.")

        @OptionGroup var options: Options

        func run() async throws {
            guard let login = try await options.login() else {
                return
            }
            try await GetAuthorFeed.query(
                auth: login.accessJwt,
                with: GetAuthorFeed.Parameters(actor: login.did, limit: 10)
            )
            .dumpJson()
        }
    }

    struct Prefs: AsyncParsableCommand {
        static let configuration =
            CommandConfiguration(abstract: "Show the Author's prefs.")

        @OptionGroup var options: Options

        func run() async throws {
            guard let login = try await options.login() else {
                return
            }
            try await GetPreferences.query(auth: login.accessJwt)
                .dumpJson()
        }
    }

    struct Timeline: AsyncParsableCommand {
        static let configuration =
            CommandConfiguration(abstract: "Show the timeline.")

        @OptionGroup var options: Options

        func run() async throws {
            guard let login = try await options.login() else {
                return
            }
            var accessJwt = login.accessJwt
            var refreshJwt = login.refreshJwt

            var cursor: String? = nil
            let params = { GetTimeline.Parameters(cursor: cursor, limit: 10) }

            let call = {
                switch try await GetTimeline.query(
                    auth: accessJwt,
                    with: params()
                ) {
                case let .value(result):
                    cursor = result.cursor
                    try result.dumpJson()
                    return true
                case let .error(code, error):
                    print(code, error)
                    return false
                }
            }
            guard try await call() else { return }
            guard try await call() else { return }
            guard case let .value(result) = try await RefreshSession.call(auth: refreshJwt) else {
                return
            }
            accessJwt = result.accessJwt
            refreshJwt = result.refreshJwt
            guard try await call() else { return }
        }
    }
}
