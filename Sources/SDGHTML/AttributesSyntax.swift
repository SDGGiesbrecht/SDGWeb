/*
 AttributesSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public struct AttributesSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case attributes
        case trailingWhitespace
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal static func parse(source: inout String) -> ContentSyntax {
        let whitespace = TokenSyntax.parseWhitespace(fromEndOf: &source)
        var entries: [AttributeSyntax] = []
        while let attribute = AttributesSyntax.parse(fromEndOf: &source) {
            entries.append(attribute)
        }
        let list = ListSyntax<ContentElementSyntax>(entries: entries.reversed())
        return AttributesSyntax(_storage: [SyntaxStorage(children: [
            list,
            whitespace
            ]))
    }

    // MARK: - Children

    public var attributes: ListSyntax<AttributeSyntax> {
        return children[ContentSyntax.indices[.attributes]!] as! ListSyntax<AttributeSyntax>
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
