import ArgumentParser
import Foundation
import System

@main
struct Codegen: ParsableCommand {
    @Argument(transform: FilePath.init(stringLiteral:))
    var indir: FilePath
    @Argument(transform: FilePath.init(stringLiteral:))
    var outdir: FilePath

    func run() throws {
        let g = Generator(fromPath: indir, toPath: outdir,
                          withFileManager: FileManager.default)
        try g.rmdirs()
        try g.generate()
    }
}

struct Generator {
    let indir: FilePath
    let outdir: FilePath
    let fm: FileManager

    init(fromPath indir: FilePath, toPath outdir: FilePath,
         withFileManager fm: FileManager)
    {
        self.indir = indir
        self.outdir = outdir
        self.fm = fm
    }

    func rmdirs() throws {
        if !fm.fileExists(atFilePath: outdir) {
            return
        }

        var directories: [FilePath] = []
        for f in fm.enumerator(atFilePath: outdir)! {
            let full = outdir.appending(f as! String)
            if try fm.isDictionary(atFilePath: full) {
                directories.append(full)
            } else {
                try fm.removeItem(atFilePath: full)
            }
        }
        for d in directories.reversed() {
            try fm.removeItem(atFilePath: d)
        }

        try fm.removeItem(atFilePath: outdir)
    }

    func generate() throws {
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
                let components = full_path.removingLastComponent().components

                // app.bsky.feed.defs.swift
                let swift_file_name =
                    (components.map(\.string) + [full_path.stem!, "swift"])
                        .joined(separator: ".")
                let dst = outdir
                    .appending(components)
                    .appending(swift_file_name)
                try generate(fromFile: src, toFile: dst)
            }
        }
        try generateTag(toFile: outdir.appending(".generationTag.json"))
    }

    func generate(fromFile src: FilePath, toFile dst: FilePath) throws {
        let file =
            try JSONDecoder().decode(File.self,
                                     from: fm.contents(atFilePath: src)!)
        try fm.createFile(atFilePath: dst, contents: file.emit())
    }

    func generateTag(toFile dst: FilePath) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        try fm.createFile(atFilePath: dst,
                          contents: encoder.encode(GenerationTag()))
    }
}
