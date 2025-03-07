import Foundation
@testable import Main
import Proto
import Testing

private struct MixedParameters: Proto.ApiParameters {
    let first: String
    let second: String?
    let third: Int
    let fourth: Int?
}

private struct NoParameters: Proto.ApiParameters {}

private struct NullableParameters: Proto.ApiParameters {
    let first: String?
    let second: String?
}

extension URLQueryItem: @retroactive Comparable {
    public static func < (lhs: URLQueryItem, rhs: URLQueryItem) -> Bool {
        lhs.name < rhs.name
    }

    public static func == (lhs: URLQueryItem, rhs: URLQueryItem) -> Bool {
        lhs.name == rhs.name
    }
}

@Suite struct ParametersURLQueryItemTest {
    @Test func mixedTest() throws {
        let params = MixedParameters(first: "one", second: "two",
                                     third: 3, fourth: nil)
        let actual = try params
            .queryItems()
            .sorted()
        try #require(actual.count == 3)
        #expect(actual[0].description == "first=one")
        #expect(actual[1].description == "second=two")
        #expect(actual[2].description == "third=3")
    }

    @Test func noTest() throws {
        let params = NoParameters()
        let actual = try params.queryItems()
        #expect(actual.count == 0)
    }

    @Test func nullNoneTest() throws {
        let params = NullableParameters(first: nil, second: nil)
        let actual = try params.queryItems()
        #expect(actual.count == 0)
    }

    @Test func nullSomeTest() throws {
        let params = NullableParameters(first: "one", second: nil)
        let actual = try params.queryItems()
        try #require(actual.count == 1)
        #expect(actual[0].description == "first=one")
    }
}
