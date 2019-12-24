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
  ///   - language: The language of the redirect. This affects things like the text direction of the link that displays if the browser refuses to follow the redirect.
  ///   - target: The URL to redirect to.
  public static func redirect<L>(
    language: L,
    target: URL
  ) -> DocumentSyntax where L: Localization {
    let targetString = target.relativeString
    let arrow = language.textDirection.htmlAttribute == "ltr" ? "↳" : "↲"
    let targetWithArrow = "\(arrow) \(targetString)"
    return document(
      documentElement: .document(
        language: language,
        header: .metadataHeader(
          title: .metadataTitle(targetWithArrow),
          canonicalURL: .canonical(url: target),
          redirectDestination: .redirect(target: target),
          author: nil,
          description: .description(targetWithArrow),
          keywords: nil
        ),
        body: .body(contents: [
          .element(
            .division(contents: [
              .text("\(arrow) "),
              .element(
                .link(
                  target: target,
                  language: language,
                  contents: [
                    .text(targetString)
                  ]
                )
              )
            ])
          )
        ])
      )
    )
  }
}
