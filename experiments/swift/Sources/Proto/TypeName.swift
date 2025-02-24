// Each "unknown" object has a "$type" field and all the regular fields for
// that particular type. So the simplest solution is to define a `struct` with
// a single "$type" field, decode into that, and using the underlying name,
// decode again into the proper type. That's `AnyPet.init()`.

struct TypeName: Codable {
    let typename: String
    enum CodingKeys: String, CodingKey {
        case typename = "$type"
    }
}
