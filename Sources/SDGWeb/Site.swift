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

public struct Site {

    // MARK: - Initialization

    public init(repositoryStructure: RepositoryStructure) {
        self.repositoryStructure = repositoryStructure
    }

    // MARK: - Properties

    private let repositoryStructure: RepositoryStructure

    // MARK: - Processing

    public func generate() throws {
        try clean()
    }

    private func clean() throws {
        do {
            try FileManager.default.removeItem(at: repositoryStructure.result)
        } catch {
            throw Error.cleaningFailure(error)
        }
    }
}
