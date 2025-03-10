import Foundation

struct GenerationTag: Codable {
    let date: TimeInterval
    init() {
        date = Date.now.timeIntervalSince1970
    }
}
