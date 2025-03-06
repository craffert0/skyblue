@testable import codegen
import Testing

@Test func TypenameFullTests() throws {
    let t = try Typename("app.bsky.profilePhoto")
    #expect(t.full_name == "app.bsky.ProfilePhoto")
    #expect(t.namespace! == "app.bsky")
    #expect(t.short_name == "ProfilePhoto")
}

@Test func TypenameShortTests() throws {
    let t = try Typename("#profileView")
    #expect(t.full_name == "ProfileView")
    #expect(t.namespace == nil)
    #expect(t.short_name == "ProfileView")
    #expect(t.json_name(inNamespace: "foo.bar") == "foo.bar#profileView")
}

@Test func TypenameLongTests() throws {
    let t = try Typename("app.bsky.def#profileView")
    #expect(t.full_name == "app.bsky.def.ProfileView")
    #expect(t.namespace == "app.bsky.def")
    #expect(t.short_name == "ProfileView")
    #expect(t.json_name(inNamespace: "foo.bar") == "app.bsky.def#profileView")
}
