/*
 TokenSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A syntax node representing a single token.
public struct TokenSyntax : Syntax {

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
