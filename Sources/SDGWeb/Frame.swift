/*
 Frame.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGCollections
import SDGText
import SDGLocalization

import SDGHTML

import SDGWebLocalizations

internal enum Frame {

  #warning("Move to SDGHTML.")
  #warning("Switch to DocumentSyntax.")
  internal static func frame<L>(localization: L, css: [ElementSyntax]) -> StrictString
  where L: Localization {
    #warning("Make dynamic.")
    let author = "Author"
    let description = "Description."
    let keywords = ["keyword"]

    return StrictString(
      DocumentSyntax.document(
        documentElement: .document(
          language: localization,
          header: .metadataHeader(
            title: .metadataTitle("[*title*]"),
            canonicalURL: .canonical(url: URL(fileURLWithPath: "[*domain*]/[*relative path*]")),
            author: .author(author),
            description: .description(description),
            keywords: .keywords(keywords),
            css: css
          ),
          body: .body(contents: [
            .text("[*body*]")
          ])
        )
      ).source()
    )
  }
}
