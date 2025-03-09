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

    func getPreferences() async throws -> Response<Proto.app.bsky.actor.GetPreferences.Result> {
        typealias Query = Proto.app.bsky.actor.GetPreferences
        let request = HTTPRequest {
            $0.url = URL(string: "https://bsky.social/xrpc/\(Query.apiPath)")
            $0.method = .get
            $0.headers = HTTPHeaders(arrayLiteral: .init(name: "Authorization", value: "Bearer " + accessJwt))
        }
        let response = try await request.fetch()
        if verbose {
            print("DEBUG headers", response.headers)
        }
        return try response.decodeResponse(Proto.app.bsky.actor.GetPreferences.Result.self)
    }

    mutating func getTimeline(limit: Int = 10) async throws -> Response<Proto.app.bsky.feed.GetTimeline.Result> {
        typealias Query = Proto.app.bsky.feed.GetTimeline
        var params = Query.Parameters(limit: limit)
        if let cursor {
            params.cursor = cursor
        }
        let request = try HTTPRequest {
            $0.url = try URL(string: "https://bsky.social/xrpc/\(Query.apiPath)")?
                .appending(queryItems: params.queryItems())
            $0.method = .get
            $0.headers = HTTPHeaders(arrayLiteral: .init(name: "Authorization", value: "Bearer " + accessJwt))
        }

        let response = try await request.fetch()
        if verbose {
            print("DEBUG headers", response.headers)
        }
        let result = try response.decodeResponse(Proto.app.bsky.feed.GetTimeline.Result.self)
        if case let .value(tl) = result {
            cursor = tl.cursor
        }
        return result
    }

    func getSelfAuthorFeed(limit: Int = 10) async throws -> Response<Proto.app.bsky.feed.GetAuthorFeed.Result> {
        typealias Query = Proto.app.bsky.feed.GetAuthorFeed
        let params = Query.Parameters(actor: did, limit: limit)
        let request = try HTTPRequest {
            $0.url = try URL(string: "https://bsky.social/xrpc/\(Query.apiPath)")?
                .appending(queryItems: params.queryItems())
            $0.method = .get
            $0.headers = HTTPHeaders(arrayLiteral: .init(name: "Authorization", value: "Bearer " + accessJwt))
        }

        let response = try await request.fetch()
        if verbose {
            print("DEBUG headers", response.headers)
        }
        return try response.decodeResponse(Proto.app.bsky.feed.GetAuthorFeed.Result.self)
    }
}
