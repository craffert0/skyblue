import Foundation
import Proto
import RealHTTP

struct Session {
    let verbose: Bool
    var accessJwt: String
    var refreshJwt: String
    let did: String
    var cursor: String?

    init?(with creds: Credentials, verbose: Bool) async throws {
        self.verbose = verbose
        let response =
            try await HTTPRequest(method: .post,
                                  "https://bsky.social/xrpc/com.atproto.server.createSession",
                                  body: .json(creds)).fetch()
        if response.statusCode != .ok {
            return nil
        }
        if verbose {
            print("DEBUG headers", response.headers)
        }
        let login = try response.decode(Proto.com.atproto.server.CreateSession.Output.self)
        accessJwt = login.accessJwt
        refreshJwt = login.refreshJwt
        did = login.did
    }

    mutating func refresh() async throws {
        let request = HTTPRequest {
            $0.url = "https://bsky.social/xrpc/com.atproto.server.refreshSession"
            $0.method = .post
            $0.headers = HTTPHeaders(arrayLiteral: .init(name: "Authorization", value: "Bearer " + refreshJwt))
        }
        let response = try await request.fetch()
        if verbose {
            print("DEBUG headers", response.headers)
        }
        if response.statusCode != .ok {
            return
        }
        let new_session = try response.decode(Proto.com.atproto.server.RefreshSession.Output.self)
        accessJwt = new_session.accessJwt
        refreshJwt = new_session.refreshJwt
    }

    func getPreferences() async throws -> Proto.app.bsky.actor.GetPreferences.Result? {
        let request = HTTPRequest {
            $0.url = "https://bsky.social/xrpc/app.bsky.actor.getPreferences"
            $0.method = .get
            $0.headers = HTTPHeaders(arrayLiteral: .init(name: "Authorization", value: "Bearer " + accessJwt))
        }
        let response = try await request.fetch()
        if verbose {
            print("DEBUG headers", response.headers)
        }
        guard response.statusCode == .ok else {
            return nil
        }
        return try response.decode(Proto.app.bsky.actor.GetPreferences.Result.self)
    }

    mutating func getTimeline(limit: Int = 10) async throws -> Proto.app.bsky.feed.GetTimeline.Result? {
        let request = HTTPRequest {
            $0.url = "https://bsky.social/xrpc/app.bsky.feed.getTimeline"
            $0.method = .get
            $0.headers = HTTPHeaders(arrayLiteral: .init(name: "Authorization", value: "Bearer " + accessJwt))
            $0.addQueryParameter(name: "limit", value: String(limit))
        }
        if let cursor {
            request.addQueryParameter(name: "cursor", value: cursor)
        }

        let response = try await request.fetch()
        if verbose {
            print("DEBUG headers", response.headers)
        }
        guard response.statusCode == .ok else {
            return nil
        }
        let result = try response.decode(Proto.app.bsky.feed.GetTimeline.Result.self)
        cursor = result.cursor
        return result
    }

    func getSelfAuthorFeed(limit: Int = 10) async throws -> Proto.app.bsky.feed.GetAuthorFeed.Result? {
        let request = HTTPRequest {
            $0.url = "https://bsky.social/xrpc/app.bsky.feed.getAuthorFeed"
            $0.method = .get
            $0.headers = HTTPHeaders(arrayLiteral: .init(name: "Authorization", value: "Bearer " + accessJwt))
            $0.addQueryParameter(name: "actor", value: did)
            $0.addQueryParameter(name: "limit", value: String(limit))
        }

        let response = try await request.fetch()
        if verbose {
            print("DEBUG headers", response.headers)
        }
        guard response.statusCode == .ok else {
            return nil
        }
        return try response.decode(Proto.app.bsky.feed.GetAuthorFeed.Result.self)
    }
}
