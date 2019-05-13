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
        var source = source
        return parse(fromEndOf: &source, untilOpeningOf: nil).content
    }

    internal static func parse(fromEndOf source: inout String, untilOpeningOf element: String?) -> (tag: OpeningTagSyntax?, content: ContentSyntax) {
        var tag: OpeningTagSyntax?
        var entries: [ContentElementSyntax] = []
        while ¬source.isEmpty {
            if source.scalars.last == ">" {
                let parsedElement = ElementSyntax.parse(fromEndOf: &source)
                if parsedElement.continuation == nil,
                    parsedElement.openingTag.name.source() == element {
                    tag = parsedElement.openingTag
                } else {
                    entries.append(ContentElementSyntax(kind: .element(parsedElement)))
                }
            } else {
                entries.append(ContentElementSyntax(kind: .text(TextSyntax.parse(fromEndOf: &source))))
            }
        }
        let list = ListSyntax<ContentElementSyntax>(entries: entries.reversed())
        return (tag, ContentSyntax(_storage: SyntaxStorage(children: [list])))
    }

    // MARK: - Children

    public var elements: ListSyntax<ContentElementSyntax> {
        return children[ContentSyntax.indices[.elements]!] as! ListSyntax<ContentElementSyntax>
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
