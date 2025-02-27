import ArgumentParser
import Foundation
import System

func rmdirs(atPath path: FilePath,
            withFileManager fm: FileManager = FileManager.default) throws
{
    if !fm.fileExists(atFilePath: path) {
        return
    }

    var directories: [FilePath] = []
    for f in fm.enumerator(atFilePath: path)! {
        let full = path.appending(f as! String)
        if try fm.isDictionary(atFilePath: full) {
            directories.append(full)
        } else {
            try fm.removeItem(atFilePath: full)
        }
    }
    for d in directories.reversed() {
        try fm.removeItem(atFilePath: d)
    }
    try fm.removeItem(atFilePath: path)
}

func generate(fromFile src: FilePath, toFile dst: FilePath,
              withFileManager fm: FileManager) throws
{
    let file = try JSONDecoder().decode(File.self,
                                        from: fm.contents(atFilePath: src)!)
    try fm.createFile(atFilePath: dst, contents: file.emit())
}

func generate(fromPath indir: FilePath, toPath outdir: FilePath,
              withFileManager fm: FileManager = FileManager.default) throws
{
    try fm.createDirectory(atFilePath: outdir)
    for case let path as String in fm.enumerator(atFilePath: indir)! {
        let src = indir.appending(path)
        if try fm.isDictionary(atFilePath: src) {
            let dst = outdir.appending(path)
            try fm.createDirectory(atFilePath: dst)
        } else {
            // app/bsky/feed/defs.json
            let full_path = FilePath(path)

            // [app bsky feed]
            let dir_components = full_path.removingLastComponent().components

            // app.bsky.feed.defs.swift
            let swift_file_name =
                (dir_components.map(\.string) + [full_path.stem!, "swift"])
                    .joined(separator: ".")
            let dst = outdir
                .appending(dir_components)
                .appending(swift_file_name)
            try generate(fromFile: src, toFile: dst, withFileManager: fm)
        }
    }
}

@main
struct Codegen: ParsableCommand {
    @Argument var indir_name: String
    @Argument var outdir_name: String

    mutating func run() throws {
        let indir = FilePath(indir_name)
        let outdir = FilePath(outdir_name)
        try rmdirs(atPath: outdir)
        try generate(fromPath: indir, toPath: outdir)
    }
}
