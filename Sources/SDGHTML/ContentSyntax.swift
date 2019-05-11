/*
 ContentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public struct ContentSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case elements
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal static func parse(source: String) -> ContentSyntax {
        #warning("Needs parsing.")
        let list = ListSyntax<TokenSyntax>(entries: [TokenSyntax(kind: .text(source))])
        return ContentSyntax(_storage: SyntaxStorage(children: [list]))
    }

    // MARK: - Children

    public var elements: ListSyntax<TokenSyntax> {
        return children[ContentSyntax.indices[.elements]!] as! ListSyntax<TokenSyntax>
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
