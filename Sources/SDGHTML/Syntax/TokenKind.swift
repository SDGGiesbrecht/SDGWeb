/*
 TokenKind.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// Enumerates the kinds of tokens in HTML.
public enum TokenKind : Equatable, Hashable {

    // MARK: - Cases

    /// Text.
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

    // MARK: - Properties

    /// The textual representation of this token kind.
    var text: String {
        switch self {
        case .text(let text), .whitespace(let text), .elementName(let text), .attributeName(let text):
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
        }
    }
}
