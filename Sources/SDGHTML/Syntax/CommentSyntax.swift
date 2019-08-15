/*
 CommentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// An comment.
public struct CommentSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case openingToken
        case contents
        case closingToken
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

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
            return _storage.children[CommentSyntax.indices[.openingToken]!] as! TokenSyntax
        }
        set {
            _storage.children[CommentSyntax.indices[.openingToken]!] = newValue
        }
    }

    /// The contents.
    public var contents: TokenSyntax {
        get {
            return _storage.children[CommentSyntax.indices[.contents]!] as! TokenSyntax
        }
        set {
            _storage.children[CommentSyntax.indices[.contents]!] = newValue
        }
    }

    /// The closing token.
    public var closingToken: TokenSyntax {
        get {
            return _storage.children[CommentSyntax.indices[.closingToken]!] as! TokenSyntax
        }
        set {
            _storage.children[CommentSyntax.indices[.closingToken]!] = newValue
        }
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
