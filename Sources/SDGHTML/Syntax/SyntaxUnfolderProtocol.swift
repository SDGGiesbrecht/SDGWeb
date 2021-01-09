/*
 SyntaxUnfolderProtocol.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2021 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A type that defines individual syntax unfolding operations.
public protocol SyntaxUnfolderProtocol {

  /// Unfolds an element node.
  ///
  /// - Parameters:
  ///   - element: The element to unfold.
  func unfold(element: inout ElementSyntax) throws

  /// Unfolds an attribute node.
  ///
  /// - Parameters:
  ///   - attribute: The attribute to unfold.
  func unfold(attribute: inout AttributeSyntax) throws

  /// Unfolds a document node.
  ///
  /// - Parameters:
  ///   - document: The document to unfold.
  func unfold(document: inout DocumentSyntax) throws

  /// Unfolds a content list.
  ///
  /// - Parameters:
  ///   - contentList: The content list to unfold.
  func unfold(contentList: inout ListSyntax<ContentSyntax>) throws
}
