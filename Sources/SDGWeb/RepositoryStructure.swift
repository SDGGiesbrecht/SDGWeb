/*
 RepositoryStructure.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

public struct RepositoryStructure {

    // MARK: - Initialization

    public init(_main main: String = #file) {
        var url = URL(fileURLWithPath: main)
        for _ in 1 ... 3 {
            url.deleteLastPathComponent()
        }
        self.init(root: url)
    }

    public init(root: URL, result: URL? = nil) {
        self.root = root
        self.result = result ?? root.appendingPathComponent("Result")
    }

    // MARK: - Properties

    public let root: URL
    public let result: URL
}
