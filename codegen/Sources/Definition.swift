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
              with definitions: Definitions, required: Set<String>? = nil)
    {
        p.indent()
        let r = required ?? []
        for k in r.sorted() {
            definitions.add(self[k]!.emit(prop: k, in: class_name,
                                          on: p, required: true))
        }
        if r.count != 0, r.count != count {
            p.newline()
        }
        for k in Set(keys).subtracting(r).sorted() {
            definitions.add(self[k]!.emit(prop: k, in: class_name,
                                          on: p))
        }
        p.outdent()
    }
}

class QueryDefinition: Decodable {
    let description: String?
    let parameters: Parameters?
    let output: Output

    func emit(_ name: String, _ p: Printer) {
        let definitions = Definitions()
        let class_name = to_upper(name)
        let params_name = class_name + "_Parameters"
        let result_name = class_name + "_Result"
        if let description {
            p.comment(description)
        }
        p.println("public typealias \(class_name) = Query<\(params_name), \(result_name)>")

        p.newline()

        p.println("public struct \(params_name): Codable {")
        parameters?.properties?.emit(on: p, in: params_name, with: definitions)
        p.println("}")

        p.newline()

        p.println("public struct \(result_name): Codable {")
        output.schema?.emit_properties(p, result_name, definitions)
        p.println("}")

        definitions.emit(p)
    }

    class Parameters: Decodable {
        let properties: [String: Property]?
    }

    class Output: Decodable {
        let schema: ObjectDefinition?
    }
}

class ProcedureDefinition: Decodable {
    let description: String?
    let input: Input?
    let output: Output?

    func emit(_ name: String, _ p: Printer) {
        let definitions = Definitions()
        let class_name = to_upper(name)
        let input_name = class_name + "_Input"
        let output_name = class_name + "_Output"
        if let description {
            p.comment(description)
        }

        if input != nil {
            if output != nil {
                p.println("public typealias \(class_name) = Procedure11<\(input_name), \(output_name)>")
            } else {
                p.println("public typealias \(class_name) = Procedure10<\(input_name)>")
            }
        } else {
            if output != nil {
                p.println("public typealias \(class_name) = Procedure01<\(output_name)>")
            } else {
                p.println("public typealias \(class_name) = Procedure00")
            }
        }

        if let input {
            p.newline()
            p.println("public struct \(input_name): Codable {")
            input.schema?.emit_properties(p, class_name, definitions)
            p.println("}")
        }

        if let output {
            p.newline()
            p.println("public struct \(output_name): Codable {")
            output.schema?.emit_properties(p, class_name, definitions)
            p.println("}")
        }

        definitions.emit(p)
    }

    class Input: Decodable {
        let schema: ObjectDefinition?
    }

    class Output: Decodable {
        let schema: ObjectDefinition?
    }
}

class SubscriptionDefinition: Decodable {
    let parameters: Parameters
    let message: Message

    func emit(_ name: String, _ p: Printer) {
        let definitions = Definitions()
        let class_name = to_upper(name)
        let params_name = class_name + "_Parameters"
        let message_name = class_name + "_Message"

        p.println("public typealias \(class_name) = Subscription<\(params_name), \(message_name)>")

        p.newline()

        p.println("public struct \(params_name): Codable {")
        parameters.properties?.emit(on: p, in: class_name, with: definitions)
        p.println("}")

        p.newline()
        message.schema.emit(message_name, p)

        definitions.emit(p)
    }

    class Parameters: Decodable {
        let properties: [String: Property]?
    }

    class Message: Decodable {
        let schema: Definition
    }
}

class ObjectDefinition: Decodable {
    let required: Set<String>?
    let properties: [String: Property]?

    func emit(_ name: String, _ p: Printer) {
        let definitions = Definitions()
        let class_name = to_upper(name)
        p.println("public class \(class_name): Codable {")
        emit_properties(p, class_name, definitions)
        p.println("}")
        definitions.emit(p)
    }

    func emit_properties(_ p: Printer, _ class_name: String,
                         _ definitions: Definitions)
    {
        properties?.emit(on: p, in: class_name, with: definitions,
                         required: required)
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
        record.emit_properties(p, class_name, definitions)
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
