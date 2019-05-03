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
    ///
    /// - Parameters:
    ///     - repositoryStructure: The layout of the repository.
    ///     - domain: The domain of the website.
    ///     - localizationDirectories: The name to use for localization directories.
    ///     - pageProcessor: A page processor for generating each page.
    ///     - reportProgress: A closure to report progress as the site is assembled.
    ///     - progressReport: A string describing progress made.
    public init(
        repositoryStructure: RepositoryStructure,
        domain: UserFacing<StrictString, Localization>,
        localizationDirectories: UserFacing<StrictString, Localization>,
        pageProcessor: PageProcessor,
        reportProgress: @escaping (_ progressReport: StrictString) -> Void) {
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
        if FileManager.default.fileExists(atPath: repositoryStructure.resources.path) {
            try copyResources()
        }
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
            // @exempt(from: tests) // Foundation fails to error on Linux.
            throw Site<InterfaceLocalization>.Error.cssCopyingError(systemError: error)
        }
    }

    private func copyResources() throws {
        reportProgress(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Copying resources..."
            }
        }).resolved())
        do {
            try FileManager.default.copy(repositoryStructure.resources, to: repositoryStructure.result.appendingPathComponent("Resources"))
        } catch {
            throw Site<InterfaceLocalization>.Error.resourceCopyingError(systemError: error) // @exempt(from: tests)
        }
    }
}
