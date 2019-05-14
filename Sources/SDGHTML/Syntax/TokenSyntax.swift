/*
 TokenSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections

/// A syntax node representing a single token.
public struct TokenSyntax : Syntax {

    // MARK: - Parsing

    private static func parse(fromEndOf source: inout String, while condition: (Unicode.Scalar) -> Bool) -> TokenSyntax? {
        var start = source.scalars.endIndex
        while start ≠ source.scalars.startIndex,
            condition(source.scalars[source.scalars.index(before: start)]) {
                start = source.scalars.index(before: start)
        }
        if start == source.scalars.endIndex {
            return nil // Empty
        }
        let whitespace = String(source[start...])
        source.scalars.removeSubrange(start...)
        return TokenSyntax(kind: .whitespace(whitespace))
    }
    internal static func parseIdentifer(fromEndOf source: inout String) -> TokenSyntax? {
        return parse(fromEndOf: &source, while: { ¬$0.properties.isWhitespace ∧ $0 ∉ Set(["<", "/"]) })
    }
    internal static func parseAttribute(fromEndOf source: inout String) -> TokenSyntax? {
        return parse(fromEndOf: &source, while: { $0 ≠ "\u{22}" })
    }
    internal static func parseWhitespace(fromEndOf source: inout String) -> TokenSyntax? {
        return parse(fromEndOf: &source, while: { $0.properties.isWhitespace })
    }

    // MARK: - Initialization

    /// Creates a token of the specified kind.
    public init(kind: TokenKind) {
        tokenKind = kind
        _storage = SyntaxStorage(children: [])
    }

    // MARK: - Properties

    /// The kind of token this node represents.
    public let tokenKind: TokenKind

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
