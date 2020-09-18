/*
 CommentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGWebLocalizations

/// An comment.
public struct CommentSyntax: Syntax {

  // MARK: - Parsing

  #if !os(Windows)
  // #workaround(Swift 5.3, Automatic indices here and in the other nodes has been disconnected to dodge a COMDAT issue on Windows.)
  private enum Child: ChildSet {
    case openingToken
    case contents
    case closingToken
  }
  private static let indices = Child.indexTable()
  #endif

  internal static func parse(fromEndOf source: inout String) -> Result<CommentSyntax, SyntaxError> {
    let preservedSource = source
    source.scalars.removeLast(3)  // “‐‐>”
    guard let start = source.lastMatch(for: "<!\u{2D}\u{2D}") else {
      return .failure(
        SyntaxError(
          file: preservedSource,
          index: preservedSource.scalars.endIndex,
          description: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "A comment end marker has no corresponding start marker."
            case .deutschDeutschland:
              return "Ein Kommentarsendzeichen hat kein entsprechendes Anfangszeichen."
            }
          }),
          context: preservedSource
        )
      )
    }
    let text = String(source[start.range.upperBound...])
    source.scalars.truncate(at: start.range.lowerBound)
    return .success(
      CommentSyntax(
        openingToken: TokenSyntax(kind: .commentStart),
        contents: TokenSyntax(kind: .commentText(text)),
        closingToken: TokenSyntax(kind: .commentEnd)
      )
    )
  }

  // MARK: - Initialization

  /// Creates a comment.
  ///
  /// - Parameters:
  ///     - openingToken: The opening token.
  ///     - contents: The contents.
  ///     - closingToken: The closing token.
  public init(openingToken: TokenSyntax, contents: TokenSyntax, closingToken: TokenSyntax) {
    _storage = _SyntaxStorage(children: [openingToken, contents, closingToken])
  }

  // MARK: - Children

  /// The opening token.
  public var openingToken: TokenSyntax {
    get {
      return _storage.children[0] as! TokenSyntax
    }
    set {
      _storage.children[0] = newValue
    }
  }

  /// The contents.
  public var contents: TokenSyntax {
    get {
      return _storage.children[1] as! TokenSyntax
    }
    set {
      _storage.children[1] = newValue
    }
  }

  /// The closing token.
  public var closingToken: TokenSyntax {
    get {
      return _storage.children[2] as! TokenSyntax
    }
    set {
      _storage.children[2] = newValue
    }
  }

  // MARK: - Syntax

  public var _storage: _SyntaxStorage

  public mutating func format(indentationLevel: Int) {
    openingToken.format(indentationLevel: indentationLevel)
    contents.format(indentationLevel: indentationLevel)
    contents.whereMeaningfulSetLeadingWhitespace(to: " ")
    contents.whereMeaningfulSetTrailingWhitespace(to: " ")
    closingToken.format(indentationLevel: indentationLevel)
  }
}
