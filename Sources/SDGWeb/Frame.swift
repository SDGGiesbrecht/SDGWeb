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
  internal static func frame<L>(localization: L) -> StrictString where L : Localization {
    return StrictString(
      DocumentSyntax.document(
        documentElement: .document(
          language: localization,
          header: .metadataHeader(
            title: .metadataTitle("Title"),
            canonicalURL: .canonical(url: URL(string: "http://some.url")!),
            author: .author("Author"),
            description: .description("Description."),
            keywords: .keywords(["keyword"])
          ),
          body: .body()
        )
      ).source()
    )
  }
}
