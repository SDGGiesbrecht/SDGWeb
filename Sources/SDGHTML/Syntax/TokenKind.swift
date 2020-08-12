/*
 TokenKind.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections

/// Enumerates the kinds of tokens in HTML.
public enum TokenKind: Equatable, Hashable {

  // MARK: - Cases

  /// Content text.
  case text(String)

  /// A less‐than sign.
  case lessThan
  /// A greater‐than sign.
  case greaterThan
  /// An element name.
  case elementName(String)

  /// A slash.
  case slash

  /// Whitespace.
  case whitespace(String)
  /// An attribute name.
  case attributeName(String)
  /// An equals sign.
  case equalsSign
  /// A quotation mark.
  case quotationMark
  /// Text of an attribute value.
  case attributeText(String)

  /// A comment start marker.
  case commentStart
  /// Comment text.
  case commentText(String)
  /// A comment end marker.
  case commentEnd

  // MARK: - Properties

  /// The textual representation of this token kind.
  public var text: String {
    switch self {
    case .text(let text),
      .whitespace(let text),
      .elementName(let text),
      .attributeName(let text),
      .attributeText(let text),
      .commentText(let text):
      return text
    case .lessThan:
      return "<"
    case .greaterThan:
      return ">"
    case .slash:
      return "/"
    case .equalsSign:
      return "="
    case .quotationMark:
      return "\u{22}"
    case .commentStart:
      return "<!\u{2D}\u{2D}"
    case .commentEnd:
      return "\u{2D}\u{2D}>"
    }
  }

  // MARK: - Formatting

  private mutating func onlyOnTextTokens(closure: (inout String) -> Void) {
    switch self {
    case .text(var text):
      closure(&text)
      self = .text(text)
      self = .text(text)
    case .lessThan,
      .greaterThan,
      .elementName,
      .slash,
      .whitespace,
      .attributeName,
      .equalsSign,
      .quotationMark,
      .attributeText,
      .commentStart,
      .commentEnd:  // @exempt(from: tests) Not reachable.
      break  // @exempt(from: tests)
    case .commentText(var text):
      closure(&text)
      self = .commentText(text)
    }
  }

  internal mutating func whereMeaninfulNormalizeWhitespace() {
    onlyOnTextTokens { text in
      // #workaround(Swift 5.2.4, Web doesn’t have Foundation yet.)
      #if !os(WASI)
        let words = text.scalars.components(
          separatedBy: ConditionalPattern({ $0.isHTMLWhitespaceOrNewline })
        )
        .lazy.map { $0.contents }
        let scalars = words.lazy.filter({ ¬$0.isEmpty }).joined(separator: " ".scalars)
        text = String(String.UnicodeScalarView(scalars))
      #endif
    }
  }

  internal mutating func whereMeaningfulTrimWhitespace() {
    onlyOnTextTokens { text in
      // #workaround(Swift 5.2.4, Web doesn’t have Foundation yet.)
      #if !os(WASI)
        while text.scalars.first?.isHTMLWhitespaceOrNewline == true {
          text.scalars.removeFirst()
        }
        while text.scalars.last?.isHTMLWhitespaceOrNewline == true {
          text.scalars.removeLast()
        }
      #endif
    }
  }

  internal mutating func whereMeaningfulSetLeadingWhitespace(to whitespace: String) {
    onlyOnTextTokens { text in
      // #workaround(Swift 5.2.4, Web doesn’t have Foundation yet.)
      #if !os(WASI)
        while text.scalars.first?.isHTMLWhitespaceOrNewline == true {
          // @exempt(from: tests) Not currently reachable.
          text.scalars.removeFirst()
        }
        text.scalars.prepend(contentsOf: whitespace.scalars)
      #endif
    }
  }

  internal mutating func whereMeaningfulSetTrailingWhitespace(to whitespace: String) {
    onlyOnTextTokens { text in
      // #workaround(Swift 5.2.4, Web doesn’t have Foundation yet.)
      #if !os(WASI)
        while text.scalars.last?.isHTMLWhitespaceOrNewline == true {
          text.scalars.removeLast()
        }
        text.scalars.append(contentsOf: whitespace.scalars)
      #endif
    }
  }
}
