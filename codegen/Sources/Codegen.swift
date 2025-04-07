// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 Colin Rafferty <colin@rafferty.net>

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
        var g = Generator(fromPath: indir, toPath: outdir,
                          withFileManager: FileManager.default)
        try g.rmdirs()
        try g.generateFiles()
        try g.generateTopEnum()
    }
}

extension [String]: @retroactive Comparable {
    // Lexical
    public static func < (lhs: [String], rhs: [String]) -> Bool {
        for i in 0 ..< Swift.min(lhs.count, rhs.count) {
            if lhs[i] < rhs[i] {
                return true
            } else if rhs[i] < lhs[i] {
                return false
            }
        }
        return lhs.count < rhs.count
    }
}

struct Generator {
    let indir: FilePath
    let outdir: FilePath
    let fm: FileManager
    var namespaces: Set<[String]> = []

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
    }

    mutating func generateFiles() throws {
        if try !fm.fileExists(atFilePath: outdir) ||
            !fm.isDictionary(atFilePath: outdir)
        {
            try fm.createDirectory(atFilePath: outdir)
        }
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
                try generateFile(fromFile: src, toFile: dst)
            }
        }
    }

    mutating func generateFile(fromFile src: FilePath, toFile dst: FilePath) throws {
        let file =
            try JSONDecoder().decode(File.self,
                                     from: fm.contents(atFilePath: src)!)
        try fm.createFile(atFilePath: dst, contents: file.emit())
        namespaces.insert(file.namespace)
    }

    func generateTopEnum() throws {
        let p = Printer(inNamespace: "")
        p.println("// Generated: \(Date.now.ISO8601Format())")
        generateEnum(from: namespaces, into: p, top: true)
        try fm.createFile(atFilePath: outdir.appending("TopEnum.swift"),
                          contents: p.data)
    }

    func generateEnum(from namespace: Set<[String]>, into p: Printer,
                      top: Bool = false)
    {
        for first in Set(namespace.map { $0.first! }).sorted() {
            if top {
                p.newline()
            }
            let subset = namespace
                .filter { $0.first == first }
                .map { $0[1 ..< $0.count].map { String($0) } }
                .filter { !$0.isEmpty }
            if subset.isEmpty {
                p.println("public enum \(first) {}")
            } else {
                p.open("public enum \(first)") {
                    generateEnum(from: Set(subset), into: p)
                }
            }
        }
    }
}
