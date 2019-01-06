/*
 Site.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGControlFlow
import SDGLogic
import SDGText
import SDGLocalization

import SDGWebLocalizations

/// A website.
public struct Site<Localization> where Localization : SDGLocalization.InputLocalization {

    // MARK: - Initialization

    /// Creates a website instance.
    public init(
        repositoryStructure: RepositoryStructure,
        domain: UserFacing<StrictString, Localization>,
        localizationDirectories: UserFacing<StrictString, Localization>,
        pageProcessor: PageProcessor,
        reportProgress: @escaping (StrictString) -> Void) {
        self.repositoryStructure = repositoryStructure
        self.domain = domain
        self.localizationDirectories = localizationDirectories
        self.pageProcessor = pageProcessor
        self.reportProgress = reportProgress
    }

    // MARK: - Properties

    internal let repositoryStructure: RepositoryStructure
    internal let domain: UserFacing<StrictString, Localization>
    internal let localizationDirectories: UserFacing<StrictString, Localization>
    internal let pageProcessor: PageProcessor
    internal let reportProgress: (StrictString) -> Void

    private class Cache {
        fileprivate init() {}
        fileprivate var frame: StrictString?
    }
    private let cache = Cache()

    internal func frame() throws -> StrictString {
        return try cached(in: &cache.frame) {
            try pageProcessor.trimmedFrame(repositoryStructure: repositoryStructure)
        }
    }

    // MARK: - Processing

    /// Generates the website in its result directory.
    public func generate() throws {
        clean()
        try writePages()
        try copyCSS()
    }

    private func clean() {
        try? FileManager.default.removeItem(at: repositoryStructure.result)
    }

    private func writePages() throws {
        for templateLocation in try FileManager.default.deepFileEnumeration(in: repositoryStructure.pages)
            where templateLocation.lastPathComponent ≠ ".DS_Store" {
            let template = try PageTemplate(from: templateLocation, in: self)
            for localization in Localization.allCases {
                try template.writeResult(for: localization, of: self)
            }
        }
    }

    private func copyCSS() throws {
        reportProgress(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Copying CSS..."
            }
        }).resolved())
        do {
            try FileManager.default.copy(repositoryStructure.css, to: repositoryStructure.result.appendingPathComponent("CSS"))
            try CSS.root.save(to: repositoryStructure.result.appendingPathComponent("CSS/Root.css"))
        } catch {
            throw Site<InterfaceLocalization>.Error.cssCopyingError(systemError: error)
        }
    }
}
