/*
 SiteGenerationError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText
import SDGLocalization

import SDGHTML

import SDGWebLocalizations

/// An error encountered during site generation.
public enum SiteGenerationError: PresentableError {

  /// Foundation encountered an error.
  case foundationError(Swift.Error)

  /// The domain is invalid.
  case invalidDomain(StrictString)

  /// A page has invalid syntax.
  case syntaxError(page: StrictString, error: SyntaxError)

  /// A page has no metadata.
  case noMetadata(page: StrictString)

  /// A metadata entry has no colon separating its key from its value.
  case metadataMissingColon(line: StrictString)

  /// A page has no title.
  case missingTitle(page: StrictString)

  // MARK: - PresentableError

  public func presentableDescription() -> StrictString {
    return UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch self {
      case .foundationError(let error):
        return StrictString(error.localizedDescription)
      case .invalidDomain(let domain):
        switch localization {
        case .englishUnitedKingdom:
          return "‘\(domain)’ is not a valid domain."
        case .englishUnitedStates, .englishCanada:
          return "“\(domain)” is not a valid domain."
        case .deutschDeutschland:
          return "„\(domain)“ ist kein gültiges Bereich."
        }
      case .syntaxError(let page, let error):
        var result: StrictString
        switch localization {
        case .englishUnitedKingdom:
          result = "‘\(page)’ could not be parsed:"
        case .englishUnitedStates, .englishCanada:
          result = "“\(page)” could not be parsed:"
        case .deutschDeutschland:
          result = "„\(page)“ konnte nicht zerteilt werden:"
        }
        result.append("\n")
        result.append(contentsOf: error.presentableDescription())
        return result
      case .noMetadata(let page):
        switch localization {
        case .englishUnitedKingdom:
          return "‘\(page)’ has no metadata (‘<!\u{2D}\u{2D} ... \u{2D}\u{2D}>’)."
        case .englishUnitedStates, .englishCanada:
          return "“\(page)” has no metadata (“<!\u{2D}\u{2D} ... \u{2D}\u{2D}>”)."
        case .deutschDeutschland:
          return "„\(page)“ hat keine Metadaten („<!\u{2D}\u{2D} ... \u{2D}\u{2D}>“)."
        }
      case .metadataMissingColon(let line):
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Metadata entry has no colon:\n\(line)"
        case .deutschDeutschland:
          return "Bei einem Eintrag der Metadaten fehlt ein Doppelpunkt:\n\(line)"
        }
      case .missingTitle(let page):
        switch localization {
        case .englishUnitedKingdom:
          return
            "‘\(page)’ has no title. Declare it with the ‘title’ attribute on the root element."
        case .englishUnitedStates, .englishCanada:
          return
            "“\(page)” has no title. Declare it with the “title” attribute on the root element."
        case .deutschDeutschland:
          return
            "„\(page)“ hat keinen Titel. Titeln werden mit einer „Title“‐Eigenschaft am Wurzelelement angegeben."
        }
      }
    }).resolved()
  }
}
