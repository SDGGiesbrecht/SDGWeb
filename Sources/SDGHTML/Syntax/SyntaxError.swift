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

    private func lineDescription() -> UserFacing<StrictString, InterfaceLocalization> {
        return UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Line \(self.line.inDigits())"
            }
        })
    }

    public func presentableDescription() -> StrictString {
        return UserFacing<StrictString, InterfaceLocalization>({ localization in
            return [
                self.lineDescription().resolved(for: localization),
                self.description.resolved(for: localization),
                StrictString(self.context)
            ].joined(separator: "\n")
        }).resolved()
    }
}
