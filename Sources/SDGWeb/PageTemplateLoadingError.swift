/*
 PageTemplateLoadingError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2022 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGHTML

internal enum PageTemplateLoadingError: Error {
  case foundationError(Swift.Error)
  case syntaxError(page: StrictString, error: SyntaxError)
}
