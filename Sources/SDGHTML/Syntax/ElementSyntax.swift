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

    internal static func parse(fromEndOf source: inout String) -> Result<ElementSyntax, SyntaxError> {
        switch AttributesSyntax.parse(fromEndOf: &source) {
        case .failure(let error):
            return .failure(error)
        case .success(let (name, attributes)):
            if source.scalars.isEmpty {
                #warning("Throw. Extraneous “>”.")
                return .failure(SyntaxError())
            }
            if source.scalars.last ≠ "/" {
                source.scalars.removeLast() // “<”
                return .success(ElementSyntax(_storage: SyntaxStorage(children: [
                    OpeningTagSyntax(name: name, attributes: attributes),
                    nil
                    ])))
            } else {
                source.scalars.removeLast() // “/”
                if source.scalars.last ≠ "<" {
                    #warning("Throw. Extraneous “>”.")
                    return .failure(SyntaxError())
                } else {
                    source.scalars.removeLast() // “<”
                    switch ContentSyntax.parse(fromEndOf: &source, untilOpeningOf: name.source()) {
                    case .failure(let error):
                        return .failure(error)
                    case .success(let (opening, content)):
                        return .success(ElementSyntax(_storage: SyntaxStorage(children: [
                            opening,
                            ElementContinuationSyntax(
                                content: content,
                                closingTag: ClosingTagSyntax(name: name))
                            ])))
                    }
                }
            }
        }
    }

    // MARK: - Children

    public var openingTag: OpeningTagSyntax {
        return children[ElementSyntax.indices[.openingTag]!] as! OpeningTagSyntax
    }

    public var continuation: ElementContinuationSyntax? {
        return children[ElementSyntax.indices[.continuation]!] as? ElementContinuationSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
