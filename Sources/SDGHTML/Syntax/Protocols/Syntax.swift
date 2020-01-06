/*
 Syntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow
import SDGLogic

/// A Syntax node.
public protocol Syntax: TransparentWrapper, TextOutputStreamable {
  var _storage: _SyntaxStorage { get set }

  /// Applies systematic formatting to the HTML source node.
  ///
  /// - Parameters:
  ///     - indentationLevel: How deep the node is indented.
  mutating func format(indentationLevel: Int)

  /// Unfolds any custom pseudo‐elements in the node’s contents towards standard HTML.
  ///
  /// - Parameters:
  ///   - unfolder: A syntax unfolder that defines the individual unfolding operations.
  mutating func performSingleUnfoldingPass<Unfolder>(with unfolder: Unfolder) throws
  where Unfolder: SyntaxUnfolderProtocol
}

extension Syntax {

  /// The source of this node.
  public func source() -> String {
    var result = ""
    write(to: &result)
    return result
  }

  /// The children of this node.
  public var children: [Syntax] {
    return _storage.children.compactMap { $0 }
  }

  /// All the desendend nodes, at all nesting levels (including the node itself).
  public func descendents() -> [Syntax] {
    return children.lazy.flatMap({ $0.descendents() }).prepending(self)
  }

  /// Applies systematic formatting to the HTML source node.
  public mutating func format() {
    format(indentationLevel: 0)
  }

  public mutating func format(indentationLevel: Int) {
    for index in _storage.children.indices {
      _storage.children[index]?.format(indentationLevel: indentationLevel)
    }
  }

  internal mutating func unfoldChildren<Unfolder>(with unfolder: Unfolder) throws
  where Unfolder: SyntaxUnfolderProtocol {
    for index in _storage.children.indices {
      try _storage.children[index]?.performSingleUnfoldingPass(with: unfolder)
    }
  }
  public mutating func performSingleUnfoldingPass<Unfolder>(with unfolder: Unfolder) throws
  where Unfolder: SyntaxUnfolderProtocol {
    try unfoldChildren(with: unfolder)
  }

  /// Recursively unfolds any custom pseudo‐elements in the node’s contents toward standard HTML.
  ///
  /// - Parameters:
  ///   - unfolder: A syntax unfolder that defines the individual unfolding operations.
  public mutating func unfold<Unfolder>(with unfolder: Unfolder) throws
  where Unfolder: SyntaxUnfolderProtocol {
    let before = source()
    try performSingleUnfoldingPass(with: unfolder)
    if source() ≠ before {
      try unfold(with: unfolder)
    }
  }

  /// Recursively unfolds any custom pseudo‐elements in the node’s contents toward standard HTML using the default syntax unfolder.
  ///
  /// The default syntax unfolder lacks any context information and thus will not unfold elements like `<page>` or `<localized>`. See `SyntaxUnfolder.init(context:)` for more information.
  public mutating func unfold() throws {
    try unfold(
      with: SyntaxUnfolder(
        context: SyntaxUnfolder.Context(
          localization: Optional<AnyLocalization>.none,
          siteRoot: nil,
          relativePath: nil
        )
      )
    )
  }

  /// Returns the HTML node with systematic formatting applied to its source.
  ///
  /// - Parameters:
  ///     - indentationLevel: Optional. How deep the node is nested.
  public func formatted(indentationLevel: Int = 0) -> Self {
    return nonmutatingVariant(of: { $0.format(indentationLevel: indentationLevel) }, on: self)
  }

  // MARK: - TextOutputStreamable

  public func write<Target>(to target: inout Target) where Target: TextOutputStream {
    if case let token as TokenSyntax = self {
      token.tokenKind.text.write(to: &target)
    } else {
      for child in children {
        child.write(to: &target)
      }
    }
  }

  // MARK: - TransparentWrapper

  public var wrappedInstance: Any {
    return source()
  }
}
