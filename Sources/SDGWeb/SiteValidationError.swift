/*
 SiteValidationError.swift

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
import SDGHTML

/// An error detected while validating a website.
public enum SiteValidationError: PresentableError {

  // MARK: - Cases

  /// Foundation encountered an error.
  case foundationError(Error)

  /// The file’s syntax could not be parsed.
  case syntaxError(SyntaxError)

  // MARK: - Properties

  public func presentableDescription() -> StrictString {
    switch self {
    case .foundationError(let error):
      // #workaround(Swift 5.2.1, Web doesn’t have Foundation yet.)
      #if os(WASI)
        return StrictString(String(describing: error))
      #else
        return StrictString(error.localizedDescription)
      #endif
    case .syntaxError(let error):
      return error.presentableDescription()
    }
  }
}
