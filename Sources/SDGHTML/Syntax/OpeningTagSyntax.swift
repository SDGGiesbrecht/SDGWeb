/*
 OpeningTagSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public struct OpeningTagSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case lessThan
        case name
        case attributes
        case greaterThan
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal init(name: TokenSyntax, attributes: AttributesSyntax?) {
        _storage = _SyntaxStorage(children: [
            TokenSyntax(kind: .lessThan),
            name,
            attributes,
            TokenSyntax(kind: .greaterThan)
            ])
    }

    // MARK: - Children

    public var lessThan: TokenSyntax {
        return _storage.children[OpeningTagSyntax.indices[.lessThan]!] as! TokenSyntax
    }

    public var name: TokenSyntax {
        return _storage.children[OpeningTagSyntax.indices[.name]!] as! TokenSyntax
    }

    public var attributes: AttributesSyntax? {
        return _storage.children[OpeningTagSyntax.indices[.attributes]!] as? AttributesSyntax
    }

    public var greaterThan: TokenSyntax {
        return _storage.children[OpeningTagSyntax.indices[.greaterThan]!] as! TokenSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
