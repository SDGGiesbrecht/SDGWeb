/*
 SyntaxError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGWebLocalizations

/// An HTML syntax error or a violation of best practices.
public struct SyntaxError: PresentableError {

  /// Creates a syntax error.
  ///
  /// - Parameters:
  ///     - file: The source of the entire HTML document.
  ///     - index: The location of the syntax error within the file.
  ///     - description: A description of the error.
  ///     - context: An exerpt of the file containing the error.
  public init<L>(
    file: String,
    index: String.ScalarView.Index,
    description: UserFacing<StrictString, L>,
    context: String
  ) where L: Localization {

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
      case .deutschDeutschland:
        return "Zeile \(self.line.inDigits())"
      }
    })
  }

  public func presentableDescription() -> StrictString {
    return StrictString(
      [
        self.lineDescription().resolved(),
        self.description(),
        StrictString(self.context)
      ].joined(separator: "\n" as StrictString)
    )
  }
}
