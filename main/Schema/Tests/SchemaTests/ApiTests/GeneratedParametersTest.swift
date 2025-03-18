// WARNING: This assumes the code is already generated, and that the
// definition hasn't changed.

import Schema
import Testing

private typealias TestParameters =
    app.bsky.feed.GetAuthorFeed.Parameters

@Suite struct GeneratedParametersTest {
    @Test func makeNone() throws {
        let p = TestParameters()
        #expect(p.actor == nil)
        #expect(p.cursor == nil)
        #expect(p.filter == nil)
        #expect(p.includePins == nil)
        #expect(p.limit == nil)
    }

    @Test func makeSome() throws {
        let p = TestParameters(cursor: "c", includePins: false)
        #expect(p.actor == nil)
        #expect(p.cursor == "c")
        #expect(p.filter == nil)
        #expect(p.includePins == false)
        #expect(p.limit == nil)
    }
}
