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
import SDGText
import SDGLocalization

import SDGWebLocalizations

/// An HTML element.
public struct ElementSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case openingTag
        case continuation
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    private static func unpairedGreaterThan() -> UserFacing<StrictString, InterfaceLocalization> {
        return UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "A greater‐than sign has no corresponding less‐than sign."
            case .deutschDeutschland:
                return "Ein Größer‐als‐Zeichen hat kein entsprechendes Kleiner‐als‐Zeichen."
            }
        })
    }

    internal static func parse(fromEndOf source: inout String) -> Result<ElementSyntax, SyntaxError> {
        var preservedSource = source
        source.scalars.removeLast() // “>”
        switch AttributesSyntax.parse(fromEndOf: &source) {
        case .failure(let error):
            return .failure(error)
        case .success(let (name, attributes)):
            if source.scalars.isEmpty {
                return .failure(SyntaxError(
                    file: preservedSource,
                    index: preservedSource.scalars.endIndex,
                    description: unpairedGreaterThan(),
                    context: preservedSource))
            }
            if source.scalars.last ≠ "/" {
                source.scalars.removeLast() // “<”
                return .success(ElementSyntax(
                    openingTag: OpeningTagSyntax(name: name, attributes: attributes)))
            } else {
                source.scalars.removeLast() // “/”
                if source.scalars.last ≠ "<" {
                    return .failure(SyntaxError(
                        file: preservedSource,
                        index: preservedSource.scalars.endIndex,
                        description: unpairedGreaterThan(),
                        context: preservedSource))
                } else {
                    source.scalars.removeLast() // “<”
                    switch ContentSyntax.parse(fromEndOf: &source, untilOpeningOf: name.source()) {
                    case .failure(let error):
                        return .failure(error)
                    case .success(let (opening, content)):
                        guard let tag = opening else {
                            return .failure(SyntaxError(
                                file: preservedSource,
                                index: preservedSource.scalars.endIndex,
                                description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                                    switch localization {
                                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                                        return "A closing tag has no corresponding opening tag."
                                    case .deutschDeutschland:
                                        return "Eine schließende Markierung hat keine entsprechende öffnende Markierung."
                                    }
                                }),
                                context: preservedSource))
                        }
                        return .success(ElementSyntax(
                            openingTag: tag,
                            continuation: ElementContinuationSyntax(
                                content: content,
                                closingTag: ClosingTagSyntax(name: name))))
                    }
                }
            }
        }
    }

    // MARK: - Initialization

    /// Creates an element.
    ///
    /// - Parameters:
    ///     - openingTag: The opening tag.
    ///     - continuation: Optional. Any continuation node.
    public init(openingTag: OpeningTagSyntax, continuation: ElementContinuationSyntax? = nil) {
        _storage = _SyntaxStorage(children: [openingTag, continuation])
    }

    // MARK: - Children

    /// The opening tag.
    public var openingTag: OpeningTagSyntax {
        get {
            return _storage.children[ElementSyntax.indices[.openingTag]!] as! OpeningTagSyntax
        }
        set {
            _storage.children[ElementSyntax.indices[.openingTag]!] = newValue
        }
    }

    /// The content and closing tag, if the element is not empty.
    public var continuation: ElementContinuationSyntax? {
        get {
            return _storage.children[ElementSyntax.indices[.continuation]!] as? ElementContinuationSyntax
        }
        set {
            _storage.children[ElementSyntax.indices[.continuation]!] = newValue
        }
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
