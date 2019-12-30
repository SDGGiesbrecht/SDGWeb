/*
 SyntaxUnfolder.swift

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
public struct SyntaxUnfolder: SyntaxUnfolderProtocol {

  // MARK: - Static Properties

  /// The default `SyntaxUnfolder`.
  ///
  /// This syntax unfolder has no context, and will not unfold elements such as `<localized>` that require external information. To process those elements as well, creat an instance with one of the initializers.
  public static let `default`: SyntaxUnfolder = SyntaxUnfolder()

  // MARK: - Initialization

  /// Creates a syntax unfolder.
  ///
  /// - Parameters:
  ///   - localization: The localization to which to unfold localized elements.
  public init<L>(localization: L) where L: Localization {
    var localizationIdentifiers = [StrictString(localization.code)]
    if let icon = localization.icon {
      localizationIdentifiers.prepend(icon)
    }
    self.init(localizationIdentifiers: localizationIdentifiers)
  }

  /// Creates a syntax unfolder with no localization context.
  public init() {
    self.init(localizationIdentifiers: [])
  }

  private init(localizationIdentifiers: [StrictString]) {
    self.localizationIdentifiers = localizationIdentifiers
  }

  // MARK: - Properties

  private let localizationIdentifiers: [StrictString]

  // MARK: - Individual Unfolding Operations

  /// Unfolds `<foreign>` into `<span class="foreign">`.
  ///
  /// `foreign` indicates that a span of text is in a foreign language. Such text is often italicized.
  ///
  /// - Parameters:
  ///   - element: The element to unfold.
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

  public static func unfoldLocalized<L>(_ element: inout ElementSyntax, localization: L)
  where L: Localization {
    if element.isNamed(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom:
          return "localised"
        case .englishUnitedStates, .englishCanada:
          return "localized"
        case .deutschDeutschland:
          return "lokalisiert"
        }
      })
    ) {
      #warning("Not implemented yet.")
    }
  }
}
