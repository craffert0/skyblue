enum Property: Decodable {
    case string(StringProperty)
    case integer(IntegerProperty)
    case boolean(BooleanProperty)
    case ref(ReferenceProperty)
    case array(ArrayProperty)
    case union(UnionMix)
    case unknown(UnknownProperty)
    case blob(BlobProperty)
    case bytes(BytesProperty)
    case cid_link(CidLinkProperty)

    init(from decoder: Decoder) throws {
        let svc = try decoder.singleValueContainer()
        let typename = try svc.decode(TypeDecoder.self).type
        switch typename {
        case "string":
            self = try .string(svc.decode(StringProperty.self))
        case "boolean":
            self = try .boolean(svc.decode(BooleanProperty.self))
        case "integer":
            self = try .integer(svc.decode(IntegerProperty.self))
        case "ref":
            self = try .ref(svc.decode(ReferenceProperty.self))
        case "array":
            self = try .array(svc.decode(ArrayProperty.self))
        case "union":
            self = try .union(svc.decode(UnionMix.self))
        case "unknown":
            self = try .unknown(svc.decode(UnknownProperty.self))
        case "blob":
            self = try .blob(svc.decode(BlobProperty.self))
        case "bytes":
            self = try .bytes(svc.decode(BytesProperty.self))
        case "cid-link":
            self = try .cid_link(svc.decode(CidLinkProperty.self))
        default:
            throw SchemaError.invalidTypeName(name: typename)
        }
    }

    func emit(prop prop_name: String, in class_name: String, on p: Printer,
              required: Bool = false) -> (name: String,
                                          definition: Definition)?
    {
        if let description {
            p.comment(description)
        }
        let type_name = type_name(class_name, prop_name)
        p.println("public let \(prop_name): \(type_name)\(required ? "" : "?")")
        return newType(prop: prop_name, in: class_name)
    }

    func newType(prop prop_name: String,
                 in class_name: String) -> (name: String,
                                            definition: Definition)?
    {
        switch self {
        case let .union(union):
            (type_name(class_name, prop_name), .union(union))
        case let .array(array):
            array.items.newType(prop: prop_name, in: class_name)
        default:
            nil
        }
    }

    var description: String? {
        switch self {
        case let .string(string):
            string.description
        case let .integer(integer):
            integer.description
        case let .boolean(boolean):
            boolean.description
        case let .ref(ref):
            ref.description
        case let .array(array):
            array.description
        case let .union(union):
            union.description
        case let .unknown(unknown):
            unknown.description
        case let .blob(blob):
            blob.description
        case let .bytes(bytes):
            bytes.description
        case let .cid_link(cid_link):
            cid_link.description
        }
    }

    func type_name(_ class_name: String, _ prop_name: String) -> String {
        switch self {
        case .string:
            "String"
        case .integer:
            "Int"
        case .boolean:
            "Bool"
        case let .ref(ref):
            ref.ref.full_name
        case let .array(array):
            "[\(array.items.type_name(class_name, prop_name))]"
        case .union:
            unionName(for: prop_name, in: class_name)
        case .blob:
            "Blob"
        case .bytes:
            "Bytes"
        case .unknown:
            "Unknown"
        case .cid_link:
            "CidLink"
        }
    }
}

class StringProperty: Decodable {
    let description: String?
    let format: String?
}

class IntegerProperty: Decodable {
    let description: String?
}

class BooleanProperty: Decodable {
    let description: String?
}

class ReferenceProperty: Decodable {
    let ref: Typename
    let description: String?
}

class ArrayProperty: Decodable {
    let items: Property
    let description: String?
    let maxLength: Int?
}

class UnknownProperty: Decodable {
    let description: String?
}

class BlobProperty: Decodable {
    let description: String?
    let accept: [String]?
    let maxSize: Int?
}

class BytesProperty: Decodable {
    let description: String?
    let maxLength: Int?
}

class CidLinkProperty: Decodable {
    let description: String?
}

func unionName(for prop_name: String, in class_name: String) -> String {
    class_name + "_" + prop_name + "_union"
}
