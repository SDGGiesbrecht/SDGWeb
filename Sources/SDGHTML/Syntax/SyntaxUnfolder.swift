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

  // MARK: - Initialization

  /// Creates a syntax unfolder.
  ///
  /// - Parameters:
  ///   - localization: The localization to which to unfold localized elements.
  public init<L>(localization: L) where L: Localization {
    self.init(anyLocalization: AnyLocalization(localization))
  }

  /// Creates a syntax unfolder with no localization context.
  ///
  /// This unfolder will not unfold `<localized>` elements.
  public init() {
    self.init(anyLocalization: nil)
  }

  private init(anyLocalization localization: AnyLocalization?) {
    self.localization = localization
  }

  // MARK: - Properties

  private let localization: AnyLocalization?

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

  // MARK: - SyntaxUnfolderProtocol

  public func unfold(element: inout ElementSyntax) {
    SyntaxUnfolder.unfoldForeign(&element)
    if let localization = self.localization {
      SyntaxUnfolder.unfoldLocalized(&element, localization: localization)
    }
  }
}
