/*
 Unfolder.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGHTML
import SDGWeb

struct Unfolder: SiteSyntaxUnfolder {

  // MARK: - Initializer

  init(context: SyntaxUnfolder.Context) {
    standardUnfolder = SyntaxUnfolder(context: context)
  }

  // MARK: - Properties

  private let standardUnfolder: SyntaxUnfolder

  // MARK: - Individual Unfolding Operations

  func unfold(frame: inout ElementSyntax) {
    frame = .page(
      attributes: frame.attributeDictionary,
      contents: [
        .element(
          .header(contents: [
            .element(
              .paragraph(contents: [
                .element(
                  .localized([
                    .element(.english([.text("Header")])),
                    .element(.deutsch([.text("Kopfzeilen")])),
                    .element(.עברית([.text("כותרת עליונה")])),
                    .element(.unknownLanguage([.text("?")])),
                  ])
                )
              ]
              )
            )
          ])
        ),
        .element(.division(attributes: ["id": "content"], contents: frame.content)),
        .element(
          .footer(contents: [
            .element(
              .paragraph(contents: [
                .element(
                  .localized([
                    .element(.english([.text("Footer")])),
                    .element(.deutsch([.text("Fußzeilen")])),
                    .element(.עברית([.text("כותרת תחתונה")])),
                    .element(.unknownLanguage([.text("?")])),
                  ])
                )
              ]
              )
            )
          ])
        ),
      ]
    )
  }

  // MARK: - SyntaxUnfolderProtocol

  func unfold(element: inout ElementSyntax) throws {
    if element.nameText == "frame" {
      unfold(frame: &element)
    }
    try standardUnfolder.unfold(element: &element)
  }

  func unfold(attribute: inout AttributeSyntax) throws {
    try standardUnfolder.unfold(attribute: &attribute)
  }

  func unfold(document: inout DocumentSyntax) throws {
    try standardUnfolder.unfold(document: &document)
  }

  func unfold(contentList: inout ListSyntax<ContentSyntax>) throws {
    try standardUnfolder.unfold(contentList: &contentList)
  }
}
