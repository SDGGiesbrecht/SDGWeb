/*
 ContentSyntaxKind.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2024 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Enumerates the kinds of content piece.
public enum ContentSyntaxKind: Sendable {

  /// A `TextSyntax` instance.
  case text(TextSyntax)

  /// An element.
  case element(ElementSyntax)

  /// A comment.
  case comment(CommentSyntax)

  // MARK: - Formatting

  private mutating func onlyOnTextNodes(closure: (inout TextSyntax) -> Void) {
    switch self {
    case .text(var text):
      closure(&text)
      self = .text(text)
    case .element, .comment:
      break
    }
  }

  internal mutating func whereMeaningfulSetLeadingWhitespace(to whitespace: String) {
    onlyOnTextNodes { text in
      text.setLeadingWhitespace(to: whitespace)
    }
  }

  internal mutating func whereMeaningfulSetTrailingWhitespace(to whitespace: String) {
    onlyOnTextNodes { text in
      text.setTrailingWhitespace(to: whitespace)
    }
  }
}
