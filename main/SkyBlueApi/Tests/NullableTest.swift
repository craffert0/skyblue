import Foundation
import SkyBlueApi
import Testing

extension Nullable where T: Equatable {
    static func == (lhs: Nullable, rhs: Nullable) -> Bool {
        switch (lhs, rhs) {
        case (.null, .null):
            true
        case let (.value(a), .value(b)):
            a == b
        default:
            false
        }
    }
}

@Test func decodeStringTest() throws {
    let result = try JSONDecoder().decode(String.self,
                                          from: Data("\"foo\"".utf8))
    #expect(result == "foo")
}

@Test func nullableStringTest() throws {
    let result = try JSONDecoder().decode(Nullable<String>.self,
                                          from: Data("\"foo\"".utf8))
    #expect(result == .value("foo"))
}

@Test func nullableNullTest() throws {
    let result = try JSONDecoder().decode(Nullable<String>.self,
                                          from: Data("null".utf8))
    #expect(result == .null)
}
