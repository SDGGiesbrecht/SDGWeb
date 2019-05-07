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

    #warning("Should not throw.")
    /// Generates the website in its result directory.
    public func generate() throws -> Result<Void, SiteError> {
        clean()
        let pageWritingAttempt = try writePages()
        switch pageWritingAttempt {
        case .failure(let error):
            return .failure(error)
        case .success:
            break
        }

        try copyCSS()
        if FileManager.default.fileExists(atPath: repositoryStructure.resources.path) {
            try copyResources()
        }

        return .success(())
    }

    private func clean() {
        try? FileManager.default.removeItem(at: repositoryStructure.result)
    }

    #warning("Should not throw.")
    private func writePages() throws -> Result<Void, SiteError> {
        let fileEnumeration: [URL]
        do {
            fileEnumeration = try FileManager.default.deepFileEnumeration(in: repositoryStructure.pages)
        } catch {
            return .failure(.foundationError(error))
        }

        for templateLocation in fileEnumeration
            where templateLocation.lastPathComponent ≠ ".DS_Store" {

                let loadAttempt = PageTemplate.load(from: templateLocation, in: self)
                switch loadAttempt {
                case .failure(let error):
                    return .failure(error)
                case .success(let template):
                    for localization in Localization.allCases {
                        try template.writeResult(for: localization, of: self)
                    }
                }
        }
        return .success(())
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
            throw SiteError.cssCopyingError(systemError: error)
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
            throw SiteError.resourceCopyingError(systemError: error) // @exempt(from: tests)
        }
    }
}
