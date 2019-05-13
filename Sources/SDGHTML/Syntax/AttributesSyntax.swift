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
import SDGLocalization

import SDGWebLocalizations

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

        var error: SyntaxError?
        func parse() -> AttributeSyntax? {
            switch AttributeSyntax.parse(fromEndOf: &source) {
            case .failure(let caught):
                error = caught
                return nil
            case .success(let attribute):
                return attribute
            }
        }
        while let parsedElement = parse() {
            parsedElements.append(parsedElement)
        }
        if let thrown = error {
            return .failure(thrown)
        }

        if parsedElements.isEmpty {
            return .failure(SyntaxError(
                file: source,
                index: source.endIndex,
                description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "A tag is empty."
                    }
                }),
                context: "<>"))
        }
        let parsedName = parsedElements.removeLast()
        let attributes: [AttributeSyntax] = parsedElements.reversed()

        let name = parsedName.name
        if parsedName.value ≠ nil {

            var context = "<" + parsedName.source()
            context += (attributes.lazy.map({ $0.source() }).joined() as String)
            context += (whitespace?.source() ?? "") + ">"

            return .failure(SyntaxError(
                file: source + parsedName.source(),
                index: source.scalars.index(before: source.scalars.endIndex),
                description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "A tag has no name."
                    }
                }),
                context: context))
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
