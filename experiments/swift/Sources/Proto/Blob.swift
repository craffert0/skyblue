public struct Blob: Codable {
    let ref: BlobRef
    let mimeType: String
    let size: Int
}

public struct BlobRef: Codable {
    let link: String

    enum CodingKeys: String, CodingKey {
        case link = "$link"
    }
}
