/*
 Site.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText

public struct Site {

    // MARK: - Initialization

    public init(repositoryStructure: RepositoryStructure, pageProcessor: PageProcessor, reportProgress: @escaping (StrictString) -> Void) {
        self.repositoryStructure = repositoryStructure
        self.pageProcessor = pageProcessor
        self.reportProgress = reportProgress
    }

    // MARK: - Properties

    internal let repositoryStructure: RepositoryStructure
    internal let pageProcessor: PageProcessor
    internal let reportProgress: (StrictString) -> Void

    // MARK: - Processing

    public func generate() throws {
        try clean()
        try writePages()
    }

    private func clean() throws {
        do {
            try FileManager.default.removeItem(at: repositoryStructure.result)
        } catch {
            throw Error.cleaningError(systemError: error)
        }
    }

    private func writePages() throws {
        for templateLocation in try FileManager.default.deepFileEnumeration(in: repositoryStructure.pages)  {
            let relativePath = templateLocation.path(relativeTo: repositoryStructure.pages)
            let resultLocation = repositoryStructure.result.appendingPathComponent(relativePath)
            let template = try PageTemplate(from: templateLocation, in: self)
            try template.writeResult(to: resultLocation, for: self)
        }
    }
}
