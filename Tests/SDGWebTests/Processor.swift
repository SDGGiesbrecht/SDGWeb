/*
 Processor.swift

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
import SDGWeb

struct Processor: PageProcessor {

  public func syntaxUnfolder<L>(
    localization: L,
    siteRoot: URL,
    relativePath: String,
    author: ElementSyntax,
    css: [String]
  ) -> AnySyntaxUnfolder
  where L: Localization {
    return AnySyntaxUnfolder(
      SyntaxUnfolder(
        context: SyntaxUnfolder.Context(
          localization: localization,
          siteRoot: siteRoot,
          relativePath: relativePath,
          author: author,
          css: css
        )
      )
    )
  }
}
