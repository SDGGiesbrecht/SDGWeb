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

/// An attribute list.
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
                index: source.scalars.endIndex,
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
                file: source,
                index: source.scalars.endIndex,
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
        return .success((name, AttributesSyntax(attributes: list, trailingWhitespace: whitespace)))
    }

    // MARK: - Initialization

    /// Creates an attribute list.
    ///
    /// - Parameters:
    ///     - attributes: Any attributes.
    ///     - trailingWhitespace: Any trailing whitespace.
    public init(
        attributes: ListSyntax<AttributeSyntax>?,
        trailingWhitespace: TokenSyntax? = nil) {
        _storage = SyntaxStorage(children: [attributes, trailingWhitespace])
    }

    // MARK: - Children

    /// The attributes.
    public var attributes: ListSyntax<AttributeSyntax>? {
        get {
            return _storage.children[AttributesSyntax.indices[.attributes]!] as? ListSyntax<AttributeSyntax>
        }
        set {
            _storage.children[AttributesSyntax.indices[.attributes]!] = newValue
        }
    }

    /// Any trailing whitespace.
    public var trailingWhitespace: TokenSyntax? {
        get {
            return _storage.children[AttributesSyntax.indices[.trailingWhitespace]!] as? TokenSyntax
        }
        set {
            _storage.children[AttributesSyntax.indices[.trailingWhitespace]!] = newValue
        }
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
