/*
 DocumentSyntax+Factories.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLocalization

extension DocumentSyntax {

  /// Creates a document.
  ///
  /// - Parameters:
  ///   - documentElement: The document element (`<html>`).
  public static func document(
    documentElement: ElementSyntax
  ) -> DocumentSyntax {
    return DocumentSyntax(content: [
      .element(.documentTypeDeclaration()),
      .element(documentElement)
    ]).formatted()
  }

  /// Creates an HTML document functioning as a redirect.
  ///
  /// This kind of redirect should only be used as a fallback when the server configuration is unavailable for modification.
  ///
  /// - Parameters:
  ///     - target: The URL to redirect to.
  public static func redirect(
    textDirection: TextDirection,
    target: URL
  ) -> DocumentSyntax {
    enum NoLinguisticContent: String, Localization {
      case noLinguisticContent = "zxx"
      static var fallbackLocalization: NoLinguisticContent = .noLinguisticContent
    }
    let targetString = target.relativeString
    let arrow = textDirection.htmlAttribute == "ltr" ? "↳" : "↲"
    let targetWithArrow = "\(arrow) \(targetString)"
    return document(
      documentElement: .document(
        language: NoLinguisticContent.noLinguisticContent,
        attributes: ["dir": textDirection.htmlAttribute],
        header: .metadataHeader(
          title: .metadataTitle(targetWithArrow),
          description: .description(targetWithArrow),
          keywords: .keywords([]),
          author: .author("Author?")
        ),
        body: .body()
      )
    )
  }
}
