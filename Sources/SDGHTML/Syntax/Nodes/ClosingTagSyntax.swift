/*
 ClosingTagSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2022 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A closing tag.
public struct ClosingTagSyntax: NamedSyntax, Syntax {

  // MARK: - Parsing

  private enum Child: ChildSet {
    case lessThan
    case slash
    case name
    case greaterThan
  }
  private static let indices = Child.indexTable()

  // MARK: - Initialization

  /// Creates an closing tag.
  ///
  /// - Parameters:
  ///     - lessThan: The less‐than sign. (Supplied automatically if omitted.)
  ///     - slash: The slash. (Supplied automatically if omitted.)
  ///     - name: The tag name.
  ///     - greaterThan: The greater‐than sign. (Supplied automatically if omitted.)
  public init(
    lessThan: TokenSyntax = TokenSyntax(kind: .lessThan),
    slash: TokenSyntax = TokenSyntax(kind: .slash),
    name: TokenSyntax,
    greaterThan: TokenSyntax = TokenSyntax(kind: .greaterThan)
  ) {
    _storage = SyntaxStorage(children: [lessThan, slash, name, greaterThan])
  }

  /// Creates an closing tag.
  ///
  /// - Parameters:
  ///     - name: The element name.
  public init(name: TokenKind) {
    self.init(name: TokenSyntax(kind: name))
  }

  /// Creates an closing tag.
  ///
  /// - Parameters:
  ///     - name: The element name.
  public init(name: String) {
    self.init(name: .elementName(name))
  }

  // MARK: - Children

  /// The less‐than sign.
  public var lessThan: TokenSyntax {
    get {
      return _storage.children[ClosingTagSyntax.indices[.lessThan]!] as! TokenSyntax
    }
    set {
      _storage.children[ClosingTagSyntax.indices[.lessThan]!] = newValue
    }
  }

  /// The slash.
  public var slash: TokenSyntax {
    get {
      return _storage.children[ClosingTagSyntax.indices[.slash]!] as! TokenSyntax
    }
    set {
      _storage.children[ClosingTagSyntax.indices[.slash]!] = newValue
    }
  }

  /// The tag name.
  public var name: TokenSyntax {
    get {
      return _storage.children[ClosingTagSyntax.indices[.name]!] as! TokenSyntax
    }
    set {
      _storage.children[ClosingTagSyntax.indices[.name]!] = newValue
    }
  }

  /// The greater‐than sign.
  public var greaterThan: TokenSyntax {
    get {
      return _storage.children[ClosingTagSyntax.indices[.greaterThan]!] as! TokenSyntax
    }
    set {
      _storage.children[ClosingTagSyntax.indices[.greaterThan]!] = newValue
    }
  }

  // MARK: - NamedSyntax

  public static func nameTokenKind(_ text: String) -> TokenKind {
    return OpeningTagSyntax.nameTokenKind(text)
  }

  // MARK: - Syntax

  public var _storage: _SyntaxStorage
}
