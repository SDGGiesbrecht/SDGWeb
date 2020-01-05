/*
 PageProcessor.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGHTML

import SDGWebLocalizations

/// A page processor.
public protocol PageProcessor {

  /// Returns an syntax unfolder configured for the specified localization.
  func syntaxUnfolder<L>(localization: L) -> AnySyntaxUnfolder where L: Localization
}

extension PageProcessor {

  public func syntaxUnfolder<L>(localization: L) -> AnySyntaxUnfolder where L: Localization {
    return AnySyntaxUnfolder(SyntaxUnfolder(localization: localization))
  }
}
