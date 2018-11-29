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

public protocol PageProcessor {

    func frame(repositoryStructure: RepositoryStructure) throws -> StrictString

    func process(
        pageTemplate: inout StrictString,
        title: StrictString,
        content: StrictString,
        siteRoot: StrictString,
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