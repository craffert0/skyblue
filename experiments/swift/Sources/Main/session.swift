import Foundation
import Proto
import RealHTTP

extension ApiQuery {
    static func query(auth: String, with params: Parameters? = nil) async throws -> Response<Result> {
        var url = URL(string: "https://bsky.social/xrpc/\(apiPath)")
        if let params {
            try url?.append(queryItems: params.queryItems())
        }
        let request = HTTPRequest {
            $0.url = url
            $0.method = .get
            $0.headers = HTTPHeaders(arrayLiteral: .init(name: "Authorization", value: "Bearer " + auth))
        }

        let response = try await request.fetch()
        return try response.decodeResponse(Result.self)
    }
}

extension ApiProcedure11 {
    static func call(with input: Input, auth: String? = nil) async throws -> Response<Output> {
        let request = HTTPRequest {
            $0.url = URL(string: "https://bsky.social/xrpc/\(apiPath)")
            $0.method = .post
            $0.body = .json(input)
        }
        if let auth {
            request.headers =
                HTTPHeaders(arrayLiteral: .init(name: "Authorization", value: "Bearer " + auth))
        }
        let response = try await request.fetch()
        return try response.decodeResponse(Output.self)
    }
}

extension ApiProcedure01 {
    static func call(auth: String? = nil) async throws -> Response<Output> {
        let request = HTTPRequest {
            $0.url = URL(string: "https://bsky.social/xrpc/\(apiPath)")
            $0.method = .post
        }
        if let auth {
            request.headers =
                HTTPHeaders(arrayLiteral: .init(name: "Authorization", value: "Bearer " + auth))
        }
        let response = try await request.fetch()
        return try response.decodeResponse(Output.self)
    }
}

struct Session {
    let verbose: Bool
    var accessJwt: String
    var refreshJwt: String
    let did: String
    var cursor: String?

    init?(with creds: Credentials, verbose: Bool) async throws {
        self.verbose = verbose
        typealias Request = com.atproto.server.CreateSession
        switch try await Request.call(with: creds) {
        case let .value(login):
            accessJwt = login.accessJwt
            refreshJwt = login.refreshJwt
            did = login.did
        case let .error(code, error):
            print(code, error)
            return nil
        }
    }

    mutating func refresh() async throws {
        typealias Request = com.atproto.server.RefreshSession
        switch try await Request.call(auth: refreshJwt) {
        case let .value(login):
            accessJwt = login.accessJwt
            refreshJwt = login.refreshJwt
        case let .error(code, error):
            print(code, error)
        }
    }

    func getPreferences() async throws -> Response<Proto.app.bsky.actor.GetPreferences.Result> {
        try await Proto.app.bsky.actor.GetPreferences.query(auth: accessJwt)
    }

    mutating func getTimeline(limit: Int = 10) async throws -> Response<Proto.app.bsky.feed.GetTimeline.Result> {
        typealias Query = Proto.app.bsky.feed.GetTimeline
        var params = Query.Parameters(limit: limit)
        if let cursor {
            params.cursor = cursor
        }
        let result = try await Query.query(auth: accessJwt, with: params)
        if case let .value(tl) = result {
            cursor = tl.cursor
        }
        return result
    }

    func getSelfAuthorFeed(limit: Int = 10) async throws -> Response<Proto.app.bsky.feed.GetAuthorFeed.Result> {
        typealias Query = Proto.app.bsky.feed.GetAuthorFeed
        let params = Query.Parameters(actor: did, limit: limit)
        return try await Query.query(auth: accessJwt, with: params)
    }
}
