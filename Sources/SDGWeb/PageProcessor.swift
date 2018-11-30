/*
 PageProcessor.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText

import SDGWebLocalizations

/// A page processor.
public protocol PageProcessor {

    /// Returns the frame to use for each page of the site.
    func frame(repositoryStructure: RepositoryStructure) throws -> StrictString

    /// Processes the page template, inserting its components into the frame.
    func process(
        pageTemplate: inout StrictString,
        title: StrictString,
        content: StrictString,
        siteRoot: StrictString,
        localizationRoot: StrictString,
        relativePath: StrictString)
}

extension PageProcessor {

    public func frame(repositoryStructure: RepositoryStructure) throws -> StrictString {
        do {
            return try StrictString(from: repositoryStructure.frame)
        } catch {
            throw Site<InterfaceLocalization>.Error.frameLoadingError(error: error)
        }
    }

    func trimmedFrame(repositoryStructure: RepositoryStructure) throws -> StrictString {
        var result = try frame(repositoryStructure: repositoryStructure)
        if result.last == "\n" {
            result.removeLast()
        }
        return result
    }
}
