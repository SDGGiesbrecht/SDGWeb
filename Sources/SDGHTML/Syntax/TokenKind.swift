/*
 TokenKind.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGCollections

/// Enumerates the kinds of tokens in HTML.
public enum TokenKind : Equatable, Hashable {

    // MARK: - Cases

    /// Content text.
    case text(String)

    /// A less‐than sign.
    case lessThan
    /// A greater‐than sign.
    case greaterThan
    /// An element name.
    case elementName(String)

    /// A slash.
    case slash

    /// Whitespace.
    case whitespace(String)
    /// An attribute name.
    case attributeName(String)
    /// An equals sign.
    case equalsSign
    /// A quotation mark.
    case quotationMark
    /// Text of an attribute value.
    case attributeText(String)

    /// A comment start marker.
    case commentStart
    /// Comment text.
    case commentText(String)
    /// A comment end marker.
    case commentEnd

    // MARK: - Properties

    /// The textual representation of this token kind.
    var text: String {
        switch self {
        case .text(let text),
             .whitespace(let text),
             .elementName(let text),
             .attributeName(let text),
             .attributeText(let text),
             .commentText(let text):
            return text
        case .lessThan:
            return "<"
        case .greaterThan:
            return ">"
        case .slash:
            return "/"
        case .equalsSign:
            return "="
        case .quotationMark:
            return "\u{22}"
        case .commentStart:
            return "<!\u{2D}\u{2D}"
        case .commentEnd:
            return "\u{2D}\u{2D}>"
        }
    }

    // MARK: - Formatting

    internal mutating func whereMeaningfulSetLeadingWhitespace(to whitespace: String) {
        switch self {
        case .text(var text):
            text.scalars = String.ScalarView(
                text.scalars.drop(while: { $0.value < 0x80 ∧ $0 ∈ CharacterSet.whitespacesAndNewlines }))
            text.scalars.prepend(contentsOf: whitespace.scalars)
            self = .text(text)
        case .lessThan, .greaterThan, .elementName, .slash, .whitespace, .attributeName, .equalsSign, .quotationMark, .attributeText, .commentStart, .commentText, .commentEnd:
            break
        }
    }
}
