/*
 PageProcessor.swift

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

/// A page processor.
public protocol PageProcessor {

  /// Returns a syntax unfolder configured with the specified context information.
  ///
  /// - Parameters:
  ///   - localization: The target localization.
  ///   - siteRoot: The URL of the site root.
  ///   - relativePath: The location of the page relative to the site root.
  ///   - author: The author declaration.
  func syntaxUnfolder<L>(
    localization: L,
    siteRoot: URL,
    relativePath: String,
    author: ElementSyntax
  ) -> AnySyntaxUnfolder
  where L: Localization
}

extension PageProcessor {

  public func syntaxUnfolder<L>(
    localization: L,
    siteRoot: URL,
    relativePath: String,
    author: ElementSyntax
  ) -> AnySyntaxUnfolder
  where L: Localization {
    return AnySyntaxUnfolder(
      SyntaxUnfolder(
        context: SyntaxUnfolder.Context(
          localization: localization,
          siteRoot: siteRoot,
          relativePath: relativePath,
          author: author
        )
      )
    )
  }
}
