/*
 AttributeSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

public struct AttributeSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case whitespace
        case name
        case value
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal static func parse(fromEndOf source: inout String) -> Result<AttributeSyntax?, SyntaxError> {
        return AttributeValueSyntax.parse(fromEndOf: &source).map { value in
            guard let name = TokenSyntax.parseIdentifer(
                fromEndOf: &source,
                createToken: { .attributeName($0) }) else {
                return nil
            }
            return AttributeSyntax(_storage: SyntaxStorage(children: [
                TokenSyntax.parseWhitespace(fromEndOf: &source),
                name,
                value
                ]))
        }
    }

    // MARK: - Children

    public var whitespace: TokenSyntax {
        return _storage.children[AttributeSyntax.indices[.whitespace]!] as! TokenSyntax
    }

    public var name: TokenSyntax {
        return _storage.children[AttributeSyntax.indices[.name]!] as! TokenSyntax
    }

    public var value: AttributeValueSyntax? {
        return _storage.children[AttributeSyntax.indices[.value]!] as? AttributeValueSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
