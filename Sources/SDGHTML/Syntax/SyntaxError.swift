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

    public init<L>(
        file: String,
        index: String.ScalarView.Index,
        description: UserFacing<StrictString, L>,
        context: String) where L : Localization {

        self.description = { description.resolved() }
        self.context = context

        let lines = file.lines
        let line = index.line(in: lines)
        self.line = lines.distance(from: lines.startIndex, to: line) + 1
    }

    private let line: Int
    private let description: () -> StrictString
    private let context: String

    // MARK: - PresentableError

    private func lineDescription() -> UserFacing<StrictString, InterfaceLocalization> {
        return UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Line \(self.line.inDigits())"
            }
        })
    }

    public func presentableDescription() -> StrictString {
        return [
            self.lineDescription().resolved(),
            self.description(),
            StrictString(self.context)
            ].joined(separator: "\n")
    }
}
