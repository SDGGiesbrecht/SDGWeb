/*
 UnfoldingError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

/// An error that encountered while unfolding a syntax node.
public struct UnfoldingError: PresentableError {

  // MARK: - Initialization

  /// Creates an unfolding error.
  ///
  /// - Parameters:
  ///     - description: A description of the error.
  ///     - node: The node where the error occurred.
  public init<L>(
    description: UserFacing<StrictString, L>,
    node: Syntax
  ) where L: Localization {
    self.description = { description.resolved() }
    self.syntaxNode = node
  }

  // MARK: - Properties

  private let description: () -> StrictString

  /// The node where the error occurred.
  public let syntaxNode: Syntax

  // MARK: - PresentableError

  public func presentableDescription() -> StrictString {
    return [
      self.description(),
      StrictString(self.syntaxNode.source())
    ].joined(separator: "\n" as StrictString)
  }
}
