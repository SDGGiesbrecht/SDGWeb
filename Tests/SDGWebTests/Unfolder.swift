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

struct Unfolder: SyntaxUnfolderProtocol {

  // MARK: - Initializer

  init(context: SyntaxUnfolder.Context) {
    standardUnfolder = SyntaxUnfolder(context: context)
  }

  // MARK: - Properties

  private let standardUnfolder: SyntaxUnfolder

  // MARK: - SyntaxUnfolderProtocol

  func unfold(element: inout ElementSyntax) throws {
    try standardUnfolder.unfold(element: &element)
  }

  func unfold(contentList: inout ListSyntax<ContentSyntax>) throws {
    try standardUnfolder.unfold(contentList: &contentList)
  }
}
