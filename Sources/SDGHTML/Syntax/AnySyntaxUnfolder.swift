/*
 AnySyntaxUnfolder.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A type‐erased syntax unfolder.
public struct AnySyntaxUnfolder: SyntaxUnfolderProtocol {

  // MARK: - Initialization

  /// Wraps a syntax unfolder.
  ///
  /// - Parameters:
  ///   - unfolder: The unfolder to wrap.
  public init<Unfolder>(_ unfolder: Unfolder) where Unfolder: SyntaxUnfolderProtocol {
    unfoldElement = { try unfolder.unfold(element: &$0) }
    unfoldContentList = { try unfolder.unfold(contentList: &$0) }
  }

  // MARK: - Properties

  private let unfoldElement: (inout ElementSyntax) throws -> Void
  private let unfoldContentList: (inout ListSyntax<ContentSyntax>) throws -> Void

  // MARK: - SyntaxUnfolderProtocol

  public func unfold(element: inout ElementSyntax) throws {
    try unfoldElement(&element)
  }

  public func unfold(contentList: inout ListSyntax<ContentSyntax>) throws {
    try unfoldContentList(&contentList)
  }
}
