/*
 ClosingTagSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public struct ClosingTagSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case lessThan
        case slash
        case name
        case greaterThan
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    // MARK: - Children

    public var lessThan: TokenSyntax {
        return children[ClosingTagSyntax.indices[.lessThan]!] as! TokenSyntax
    }

    public var slash: TokenSyntax {
        return children[ClosingTagSyntax.indices[.slash]!] as! TokenSyntax
    }

    public var name: TokenSyntax {
        return children[ClosingTagSyntax.indices[.name]!] as! TokenSyntax
    }

    public var greaterThan: TokenSyntax {
        return children[ClosingTagSyntax.indices[.greaterThan]!] as! TokenSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
