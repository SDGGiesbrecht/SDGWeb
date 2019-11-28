/*
 SiteError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText
import SDGLocalization

import SDGWebLocalizations

/// An error encountered during site generation.
public enum SiteGenerationError: PresentableError {

  /// Foundation encountered an error.
  case foundationError(Swift.Error)

  /// A page has no metadata.
  case noMetadata(page: StrictString)

  /// A metadata entry has no colon separating its key from its value.
  case metadataMissingColon(line: StrictString)

  /// A page has no title.
  case missingTitle(page: StrictString)

  // MARK: - PresentableError

  // #workaround(workspace version 0.23.1, SDGLocalization inheritance is skipped due to parser crash.)
  /// Returns a localized description of the error.
  public func presentableDescription() -> StrictString {
    return UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch self {
      case .foundationError(let error):
        return StrictString(error.localizedDescription)
      case .noMetadata(page: let page):
        switch localization {
        case .englishUnitedKingdom:
          return "‘\(page)’ has no metadata (‘<!\u{2D}\u{2D} ... \u{2D}\u{2D}>’)."
        case .englishUnitedStates, .englishCanada:
          return "“\(page)” has no metadata (“<!\u{2D}\u{2D} ... \u{2D}\u{2D}>”)."
        case .deutschDeutschland:
          return "„\(page)“ hat keine Metadaten („<!\u{2D}\u{2D} ... \u{2D}\u{2D}>“)."
        }
      case .metadataMissingColon(line: let line):
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Metadata entry has no colon:\n\(line)"
        case .deutschDeutschland:
          return "Bei einem Eintrag der Metadaten fehlt ein Doppelpunkt:\n\(line)"
        }
      case .missingTitle(page: let page):
        switch localization {
        case .englishUnitedKingdom:
          return "‘\(page)’ has no title."
        case .englishUnitedStates, .englishCanada:
          return "“\(page)” has no title."
        case .deutschDeutschland:
          return "„\(page)“ hat keinen Titel."
        }
      }
    }).resolved()
  }
}
