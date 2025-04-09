import Foundation

public extension Encodable {
    func dumpJson() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(self)
        print(String(data: data, encoding: .utf8)!)
    }
}
