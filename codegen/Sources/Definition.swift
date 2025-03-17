enum Definition: Decodable {
    case query(QueryDefinition)
    case procedure(ProcedureDefinition)
    case subscription(SubscriptionDefinition)
    case object(ObjectDefinition)
    case record(RecordDefinition)
    case string(StringDefinition)
    case token(TokenDefinition)
    case array(ArrayDefinition)
    case union(UnionMix)

    init(from decoder: Decoder) throws {
        let svc = try decoder.singleValueContainer()
        let typename = try svc.decode(TypeDecoder.self).type
        switch typename {
        case "query":
            self = try .query(svc.decode(QueryDefinition.self))
        case "procedure":
            self = try .procedure(svc.decode(ProcedureDefinition.self))
        case "subscription":
            self = try .subscription(svc.decode(SubscriptionDefinition.self))
        case "object":
            self = try .object(svc.decode(ObjectDefinition.self))
        case "record":
            self = try .record(svc.decode(RecordDefinition.self))
        case "string":
            self = try .string(svc.decode(StringDefinition.self))
        case "token":
            self = try .token(svc.decode(TokenDefinition.self))
        case "array":
            self = try .array(svc.decode(ArrayDefinition.self))
        case "union":
            self = try .union(svc.decode(UnionMix.self))
        default:
            throw SchemaError.invalidDefinitionName(name: typename)
        }
    }

    func emit(_ name: String, _ p: Printer) {
        switch self {
        case let .query(query):
            query.emit(name, p)
        case let .procedure(procedure):
            procedure.emit(name, p)
        case let .subscription(subscription):
            subscription.emit(name, p)
        case let .object(object):
            object.emit(name, p)
        case let .record(record):
            record.emit(name, p)
        case let .string(string):
            string.emit(name, p)
        case let .token(token):
            token.emit(name, p)
        case let .array(array):
            array.emit(name, p)
        case let .union(union):
            union.emit(name, p)
        }
    }
}

class Definitions {
    var definitions: [String: Definition] = [:]

    func add(_ t: (name: String, definition: Definition)?) {
        if let t {
            definitions[t.name] = t.definition
        }
    }

    func emit(_ p: Printer) {
        for (n, d) in definitions {
            p.newline()
            d.emit(n, p)
        }
    }
}

extension [String: Property] {
    func emit(on p: Printer, in class_name: String,
              with definitions: Definitions, required: Set<String>? = nil,
              mutable: Bool = false)
    {
        let r = required ?? []
        let r_sorted = r.sorted()
        let n_sorted = Set(keys).subtracting(r).sorted()
        for k in r_sorted {
            definitions.add(self[k]!.emit(prop: k, in: class_name,
                                          on: p, mutable: mutable,
                                          required: true))
        }
        if r.count != 0, r.count != count {
            p.newline()
        }
        for k in n_sorted {
            definitions.add(self[k]!.emit(prop: k, in: class_name,
                                          on: p, mutable: mutable))
        }

        p.newline()

        p.println("public init(")
        p.indent()
        var count = 0
        for name in r_sorted {
            count += 1
            let prop = self[name]!
            let comma = (count == self.count) ? "" : ","
            p.println("\(name): \(prop.type_name(class_name, name))\(comma)")
        }
        for name in n_sorted {
            count += 1
            let prop = self[name]!
            let comma = (count == self.count) ? "" : ","
            p.println("\(name): \(prop.type_name(class_name, name))? = nil\(comma)")
        }
        p.outdent()
        p.println(") {")
        p.indent()
        for name in r_sorted + n_sorted {
            p.println("self.\(name) = \(name)")
        }
        p.outdent()
        p.println("}")
    }
}

class ParametersDefinition: Decodable {
    let properties: [String: Property]?

    static func emit(_ def: ParametersDefinition?, on p: Printer,
                     with definitions: Definitions)
    {
        p.println("public struct Parameters: ApiParameters {")
        if let properties = def?.properties, properties.count > 0 {
            p.indent()
            properties.emit(on: p, in: "Parameters", with: definitions, mutable: true)
            p.outdent()
        }
        p.println("}")
    }
}

class ErrorDefinition: Decodable {
    let name: String
    let description: String?
}

extension [ErrorDefinition] {
    func emit(on p: Printer) {
        p.newline()
        p.println("public enum Error {")
        p.indent()
        for e in self {
            if let description = e.description {
                p.comment(description)
            }
            p.println("case " + e.name)
        }
        p.println("case unknown(String)")
        p.outdent()
        p.println("}")
    }
}

class QueryDefinition: Decodable {
    let description: String?
    let parameters: ParametersDefinition?
    let output: FunctionBodyDefinition?
    let errors: [ErrorDefinition]?

    func emit(_ name: String, _ p: Printer) {
        let definitions = Definitions()
        let class_name = to_upper(name)
        if let description {
            p.comment(description)
        }
        p.println("public class \(class_name): ApiQuery {")
        p.indent()

        p.println("public static let apiPath = \"\(p.namespace)\"")
        p.newline()
        ParametersDefinition.emit(parameters, on: p, with: definitions)

        if let output {
            p.newline()
            p.println("public struct Output: ApiFunctionBody {")
            output.schema?.emit_properties(p, class_name, definitions, false)
            p.println("}")
        }

        errors?.emit(on: p)

        p.outdent()
        p.println("}")

        definitions.emit(p)
    }
}

class ProcedureDefinition: Decodable {
    let description: String?
    let parameters: ParametersDefinition?
    let output: FunctionBodyDefinition?
    let input: FunctionBodyDefinition?
    let errors: [ErrorDefinition]?

    func emit(_ name: String, _ p: Printer) {
        let definitions = Definitions()
        let class_name = to_upper(name)
        if let description {
            p.comment(description)
        }

        switch (input, output) {
        case (nil, nil):
            p.println("public class \(class_name): ApiProcedure00 {")
        case (_, nil):
            p.println("public class \(class_name): ApiProcedure10 {")
        case (nil, _):
            p.println("public class \(class_name): ApiProcedure01 {")
        default:
            p.println("public class \(class_name): ApiProcedure11 {")
        }
        p.indent()
        p.println("public static let apiPath = \"\(p.namespace)\"")

        p.newline()
        ParametersDefinition.emit(parameters, on: p, with: definitions)

        if let input {
            p.newline()
            p.println("public struct Input: ApiFunctionBody {")
            input.schema?.emit_properties(p, class_name, definitions, true)
            p.println("}")
        }

        if let output {
            p.newline()
            p.println("public struct Output: ApiFunctionBody {")
            output.schema?.emit_properties(p, class_name, definitions, false)
            p.println("}")
        }

        errors?.emit(on: p)

        p.outdent()
        p.println("}")

        definitions.emit(p)
    }
}

// Query & Procedure Input & Output
class FunctionBodyDefinition: Decodable {
    let description: String?
    let schema: ObjectDefinition?
}

class SubscriptionDefinition: Decodable {
    let parameters: ParametersDefinition
    let message: Message
    let errors: [ErrorDefinition]?

    func emit(_ name: String, _ p: Printer) {
        let definitions = Definitions()
        let class_name = to_upper(name)

        p.println("public class \(class_name): ApiSubscription {")
        p.indent()

        p.println("public static let apiPath = \"\(p.namespace)\"")
        p.newline()
        ParametersDefinition.emit(parameters, on: p, with: definitions)
        p.newline()
        message.schema.emit("Message", p)

        errors?.emit(on: p)

        p.outdent()
        p.println("}")

        definitions.emit(p)
    }

    class Message: Decodable {
        let schema: Definition
    }
}

class ObjectDefinition: Decodable {
    let required: Set<String>?
    let nullable: Set<String>?
    let properties: [String: Property]?

    func emit(_ name: String, _ p: Printer) {
        let definitions = Definitions()
        let class_name = to_upper(name)
        p.println("public class \(class_name): Codable {")
        emit_properties(p, class_name, definitions, false)
        p.println("}")
        definitions.emit(p)
    }

    func emit_properties(_ p: Printer, _ class_name: String,
                         _ definitions: Definitions, _ mutable: Bool)
    {
        p.indent()
        properties?.emit(on: p, in: class_name, with: definitions,
                         required: required?.subtracting(nullable ?? []),
                         mutable: mutable)
        p.outdent()
    }
}

class RecordDefinition: Decodable {
    let description: String?
    let key: String
    let record: ObjectDefinition

    func emit(_ name: String, _ p: Printer) {
        let definitions = Definitions()
        if let description {
            p.comment(description)
        }
        let class_name = to_upper(name)
        p.println("public class \(class_name): Codable {")
        record.emit_properties(p, class_name, definitions, false)
        p.println("}")
        definitions.emit(p)
    }
}

class StringDefinition: Decodable {
    let knownValues: [String]?
    let maxLength: Int?
    let maxGraphemes: Int?

    func emit(_ name: String, _ p: Printer) {
        p.println("public typealias \(to_upper(name)) = String")
    }
}

class TokenDefinition: Decodable {
    let description: String

    func emit(_ name: String, _ p: Printer) {
        p.comment("token(\(name)): \(description)")
    }
}

class ArrayDefinition: Decodable {
    let items: Definition

    func emit(_ name: String, _ p: Printer) {
        let upper = to_upper(name)
        let element_name = upper + "_element"
        p.println("public typealias \(upper) = [\(element_name)]")
        p.newline()
        items.emit(element_name, p)
    }
}
