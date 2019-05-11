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
        var entries: [ContentElementSyntax] = []
        while ¬source.isEmpty {
            if source.scalars.last == ">" {

            } else {
                entries.append(ContentElementSyntax(_storage: <#T##_SyntaxStorage#>))
            }
        }
        let list = ListSyntax<ContentElementSyntax>(entries: entries)
        return ContentSyntax(_storage: SyntaxStorage(children: [list]))
    }

    // MARK: - Children

    public var elements: ListSyntax<ContentElementSyntax> {
        return children[ContentSyntax.indices[.elements]!] as! ListSyntax<ContentElementSyntax>
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
