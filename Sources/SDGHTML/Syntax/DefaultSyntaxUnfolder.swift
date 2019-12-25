/*
 DefaultSyntaxUnfolder.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGWebLocalizations

/// The default `SyntaxUnfolder`.
public struct DefaultSyntaxUnfolder: SyntaxUnfolder {

  public static let `default`: DefaultSyntaxUnfolder = DefaultSyntaxUnfolder()

  // MARK: - Individual Unfolding Operations

  /// Unfolds `<foreign>` into `<span class="foreign">`.
  ///
  /// `foreign` indicates that a span of text is in a foreign language. Such text is often italicized.
  public static func unfoldForeign(_ element: inout ElementSyntax) {
    if element.isNamed(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "foreign"
        case .deutschDeutschland:
          return "fremd"
        }
      })
    ) {
      element.classes.prepend(element.nameText)
      element.nameText = "span"
    }
  }
}
