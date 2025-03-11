import Foundation
import Proto
import RealHTTP

extension HTTPRequest {
    convenience init(method: HTTPMethod, _ url: URL, auth: String? = nil,
                     body: Encodable? = nil) throws
    {
        self.init {
            $0.url = url
            $0.method = method
            if let body {
                $0.body = .json(body)
            }
            if let auth {
                $0.headers =
                    HTTPHeaders(arrayLiteral: .init(name: "Authorization",
                                                    value: "Bearer " + auth))
            }
        }
    }
}
