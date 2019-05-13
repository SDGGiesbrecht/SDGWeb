/*
 ElementContinuationSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public struct ElementContinuationSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case content
        case closingTag
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    // MARK: - Children

    public var content: ContentSyntax {
        return children[ElementContinuationSyntax.indices[.content]!] as! ContentSyntax
    }

    public var closingTag: EndTagSyntax {
        return children[ElementContinuationSyntax.indices[.closingTag]!] as! EndTagSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
