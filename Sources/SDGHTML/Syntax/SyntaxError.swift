/*
 SyntaxError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

import SDGWebLocalizations

public struct SyntaxError : PresentableError {

    init() {
        #warning("Temporary.")
        line = 0
        description = UserFacing({ _ in "" })
        context = ""
    }

    init(
        file: String,
        index: String.ScalarView.Index,
        description: UserFacing<StrictString, InterfaceLocalization>,
        context: String) {

        self.description = description
        self.context = context

        let lines = file.lines
        let line = index.line(in: lines)
        self.line = lines.distance(from: lines.startIndex, to: line) + 1
    }

    internal let line: Int
    internal let description: UserFacing<StrictString, InterfaceLocalization>
    internal let context: String

    // MARK: - PresentableError

    public func presentableDescription() -> StrictString {
        #warning("Not implemented.")
        return ""
    }
}
