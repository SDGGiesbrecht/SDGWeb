/*
 TextSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections

/// A text node.
public struct TextSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case token
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal static func parse(fromEndOf source: inout String) -> TextSyntax {
        var start = source.scalars.endIndex
        while start ≠ source.scalars.startIndex,
            source[source.scalars.index(before: start)] ≠ ">" {
                start = source.scalars.index(before: start)
        }
        let text = String(source[start...])
        source.scalars.removeSubrange(start...)
        return TextSyntax(text: TokenSyntax(kind: .text(text)))
    }

    // MARK: - Initialization

    /// Creates text.
    ///
    /// - Parameters:
    ///     - text: The text.
    public init(text: TokenSyntax) {
        _storage = _SyntaxStorage(children: [text])
    }

    // MARK: - Children

    /// The text.
    public var text: TokenSyntax {
        get {
            return _storage.children[TextSyntax.indices[.token]!] as! TokenSyntax
        }
        set {
            _storage.children[TextSyntax.indices[.token]!] = newValue
        }
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}