/*
 ElementSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

public struct ElementSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case openingTag
        case continuation
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal static func parse(fromEndOf source: inout String) -> ElementSyntax {
        let (name, attributes) = AttributesSyntax.parse(fromEndOf: &source)
        if source.scalars.isEmpty {
            #warning("Throw. Extraneous “>”.")
        }
        if source.last ≠ "/" {
            source.removeLast() // “<”
            return ElementSyntax(_storage: SyntaxStorage([
                OpeningTagSyntax(name: name, attributes: attributes),
                nil
                ]))
        } else {
            source.removeLast() // “/”
            if source.last ≠ "<" {
                #warning("Throw. Extraneous “>”.")
            } else {
                source.removeLast() // “<”
                let (opening, content) = ContentSyntax.parse(fromEndOf: &source, untilOpeningOf: name)
                return ElementSyntax(_storage: [
                    opening,
                    ElementContinuationSyntax(
                        content: content,
                        closingTag: ClosingTagSyntax(name: name))
                    ])
            }
        }
        var start = source.scalars.index(before: source.scalars.endIndex)
        while start ≠ source.scalars.startIndex,
            source.scalars[start] ≠ ">" {
                start = source.scalars.index(before: start)
        }
        let text = String(source[start...])
        source.scalars.removeSubrange(start...)
        return TextSyntax(_storage: SyntaxStorage(children: [TokenSyntax(kind: .text(text))]))
    }

    // MARK: - Children

    public var openingTag: OpeningTagSyntax {
        return children[ElementSyntax.indices[.openingTag]!] as! OpeningTagSyntax
    }

    public var continuation: ElementContinuationSyntax? {
        return children[ElementSyntax.indices[.openingTag]!] as? OpeningTagSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
