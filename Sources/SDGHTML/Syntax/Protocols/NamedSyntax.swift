/*
 NamedSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2021 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGWebLocalizations

/// A node which has a single associated name.
public protocol NamedSyntax: Syntax {

  /// Creates the appropriate token kind containing the provided text.
  ///
  /// - Parameters:
  ///     - text: The text for the token.
  static func nameTokenKind(_ text: String) -> TokenKind

  /// The name token.
  var name: TokenSyntax { get set }
}

extension NamedSyntax {

  /// The name text.
  public var nameText: String {
    get {
      return name.tokenKind.text
    }
    set {
      name.tokenKind = Self.nameTokenKind(newValue)
    }
  }

  // MARK: - Internal Utilities

  internal func isNamed(_ queriedName: UserFacing<StrictString, InterfaceLocalization>) -> Bool {
    let actualName = nameText
    return InterfaceLocalization.allCases.contains(where: { localization in
      return actualName == String(queriedName.resolved(for: localization))
    })
  }
}
