import Foundation
import System

extension FileManager {
    func enumerator(atFilePath path: FilePath) -> FileManager.DirectoryEnumerator? {
        enumerator(atPath: path.string)
    }

    func contents(atFilePath path: FilePath) -> Data? {
        contents(atPath: path.string)
    }

    func createFile(atFilePath path: FilePath, contents data: Data?,
                    attributes attr: [FileAttributeKey: Any]? = nil) throws
    {
        guard createFile(atPath: path.string, contents: data, attributes: attr) else {
            throw FileManagerError.createFile(path: path)
        }
    }

    func createDirectory(atFilePath path: FilePath,
                         withIntermediateDirectories createIntermediates: Bool = false,
                         attributes: [FileAttributeKey: Any]? = nil) throws
    {
        try createDirectory(atPath: path.string,
                            withIntermediateDirectories: createIntermediates,
                            attributes: attributes)
    }

    func fileExists(atFilePath path: FilePath) -> Bool {
        fileExists(atPath: path.string)
    }

    func isDictionary(atFilePath path: FilePath) throws -> Bool {
        try attributesOfItem(atPath: path.string)[.type] as! FileAttributeType == .typeDirectory
    }

    func removeItem(atFilePath path: FilePath) throws {
        try removeItem(atPath: path.string)
    }
}

enum FileManagerError: Error {
    case createFile(path: FilePath)
}
