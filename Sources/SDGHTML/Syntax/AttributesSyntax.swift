/*
 AttributesSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

public struct AttributesSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case attributes
        case trailingWhitespace
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal static func parse(fromEndOf source: inout String) -> Result<(name: TokenSyntax, attributes: AttributesSyntax?), SyntaxError> {
        let whitespace = TokenSyntax.parseWhitespace(fromEndOf: &source)
        var parsedElements: [AttributeSyntax] = []
        while let parsedElement = AttributeSyntax.parse(fromEndOf: &source) {
            parsedElements.append(parsedElement)
        }
        if parsedElements.isEmpty {
            #warning("Throw. Empty tag.")
            return .failure(SyntaxError())
        }
        let parsedName = parsedElements.removeLast()
        let attributes: [AttributeSyntax] = parsedElements.reversed()

        let name = parsedName.name
        if parsedName.value ≠ nil {
            #warning("Throw. Tag name with attribute value.")
            return .failure(SyntaxError())
        }

        let list = attributes.isEmpty ? nil : ListSyntax<AttributeSyntax>(entries: attributes)
        if whitespace == nil,
            list == nil {
            return .success((name, nil)) // Empty.
        }
        return .success((name, AttributesSyntax(_storage: SyntaxStorage(children: [
            list,
            whitespace
            ]))))
    }

    // MARK: - Children

    public var attributes: ListSyntax<AttributeSyntax>? {
        return children[AttributesSyntax.indices[.attributes]!] as? ListSyntax<AttributeSyntax>
    }

    public var trailingWhitespace: TokenSyntax? {
        return children[AttributesSyntax.indices[.trailingWhitespace]!] as? TokenSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
