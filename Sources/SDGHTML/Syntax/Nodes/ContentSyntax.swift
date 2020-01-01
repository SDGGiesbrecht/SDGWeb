/*
 ContentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

/// A child node of a content section.
public struct ContentSyntax: Syntax {

  // MARK: - Parsing

  private enum Child: CaseIterable {
    case kind
  }
  private static let indices = Child.allCases.bijectiveIndexMapping

  // MARK: - Initialization

  /// Creates a content element node.
  ///
  /// - Parameters:
  ///     - kind: The kind of node.
  public init(kind: ContentSyntaxKind) {
    _storage = _SyntaxStorage(children: [ContentSyntax.syntax(of: kind)])
  }

  // MARK: - Properties

  /// The kind of node.
  public var kind: ContentSyntaxKind {
    get {
      return ContentSyntax.kind(of: _storage.children[ContentSyntax.indices[.kind]!]!)
    }
    set {
      _storage.children[ContentSyntax.indices[.kind]!] = ContentSyntax.syntax(of: newValue)
    }
  }

  private static func syntax(of kind: ContentSyntaxKind) -> Syntax {
    switch kind {
    case .text(let text):
      return text
    case .element(let element):
      return element
    case .comment(let comment):
      return comment
    }
  }
  private static func kind(of syntax: Syntax) -> ContentSyntaxKind {
    switch syntax {
    case let text as TextSyntax:
      return .text(text)
    case let element as ElementSyntax:
      return .element(element)
    case let comment as CommentSyntax:
      return .comment(comment)
    default:
      unreachable()
    }
  }

  // MARK: - Formatting

  internal mutating func whereMeaningfulSetLeadingWhitespace(to whitespace: String) {
    kind.whereMeaningfulSetLeadingWhitespace(to: whitespace)
  }

  internal mutating func whereMeaningfulSetTrailingWhitespace(to whitespace: String) {
    kind.whereMeaningfulSetTrailingWhitespace(to: whitespace)
  }

  // MARK: - Syntax

  public var _storage: _SyntaxStorage
}
