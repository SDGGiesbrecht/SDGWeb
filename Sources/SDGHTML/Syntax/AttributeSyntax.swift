/*
 AttributeSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public struct AttributeSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case name
        case value
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal static func parse(fromEndOf source: inout String) -> AttributeSyntax? {
        return nil
        #warning("Not implemented yet.")
    }

    // MARK: - Children

    public var name: TokenSyntax {
        return children[AttributeSyntax.indices[.name]!] as! TokenSyntax
    }

    public var value: AttributeValueSyntax? {
        return children[AttributeSyntax.indices[.value]!] as? AttributeValueSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
