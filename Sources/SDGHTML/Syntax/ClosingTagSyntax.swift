/*
 ClosingTagSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A closing tag.
public struct ClosingTagSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case lessThan
        case slash
        case name
        case greaterThan
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

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
        greaterThan: TokenSyntax = TokenSyntax(kind: .greaterThan)) {
        _storage = SyntaxStorage(children: [lessThan, slash, name, greaterThan])
    }

    // MARK: - Children

    /// The less‐than sign.
    public var lessThan: TokenSyntax {
        return _storage.children[ClosingTagSyntax.indices[.lessThan]!] as! TokenSyntax
    }

    /// The slash.
    public var slash: TokenSyntax {
        return _storage.children[ClosingTagSyntax.indices[.slash]!] as! TokenSyntax
    }

    /// The tag name.
    public var name: TokenSyntax {
        return _storage.children[ClosingTagSyntax.indices[.name]!] as! TokenSyntax
    }

    /// The greater‐than sign.
    public var greaterThan: TokenSyntax {
        return _storage.children[ClosingTagSyntax.indices[.greaterThan]!] as! TokenSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
