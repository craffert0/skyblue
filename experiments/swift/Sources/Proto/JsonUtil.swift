import Foundation

public func json_dump(_ raw: Encodable) throws {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let data = try encoder.encode(raw)
    print(String(data: data, encoding: .utf8)!)
}
