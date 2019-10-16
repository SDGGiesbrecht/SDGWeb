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
import SDGText
import SDGLocalization

import SDGWebLocalizations

/// An attribute list.
public struct AttributesSyntax : AttributedSyntax, ExpressibleByArrayLiteral, Syntax {

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
                    case .deutschDeutschland:
                        return "Eine Markierung ist lehr."
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
                    case .deutschDeutschland:
                        return "Eine Markierung hat keinen Namen."
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

    /// Creates an empty attribute list.
    public init() {
        self.init(attributes: nil)
    }

    /// Creates an attribute list from a dictionary. Returns `nil` if the dictionary is empty.
    ///
    /// - Parameters:
    ///     - dictionary: The attributes in dictionary form.
    public init?(dictionary: [String: String]) {
        guard let list = ListSyntax<AttributeSyntax>(dictionary: dictionary) else {
            return nil
        }
        self.init(attributes: list)
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

    // MARK: - AttributedSyntax

    public var attributeDictionary: [String: String] {
        get {
            return attributes?.attributeDictionary ?? [:]
        }
        set {
            attributes = ListSyntax<AttributeSyntax>(dictionary: newValue)
        }
    }

    public func attribute(named name: String) -> AttributeSyntax? {
        return attributes?.attribute(named: name)
    }

    public mutating func apply(attribute: AttributeSyntax) {
        if attributes == nil {
            attributes = []
        }
        attributes?.apply(attribute: attribute)
    }

    public mutating func removeAttribute(named name: String) {
        attributes?.removeAttribute(named: name)
        if attributes?.isEmpty ≠ false {
            attributes = nil
        }
    }

    // MARK: - ExpressibleByArrayLiteral

    public init(arrayLiteral elements: AttributeSyntax...) {
        self.init(attributes: ListSyntax(entries: elements))
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage

    public mutating func format(indentationLevel: Int) {
        attributes?.formatAttributeList(indentationLevel: indentationLevel)
        if attributes?.source().count ?? 0 > 100 {
            attributes?.setAllLeadingWhitespace(to: "\n" + String(repeating: " ", count: indentationLevel + 1))
            trailingWhitespace = TokenSyntax(kind: .whitespace("\n" + String(repeating: " ", count: indentationLevel)))
        } else {
            trailingWhitespace = nil
        }
    }
}
