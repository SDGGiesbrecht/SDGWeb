/*
 HTML.swift

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
import SDGText

/// A namespace for functions related to HTML.
public enum HTML {

    @inlinable internal static func sharedEscape<S>(_ text: inout S) where S : StringFamily {
        text.scalars.replaceMatches(for: "&".scalars, with: "&#x0026;".scalars)
    }

    /// Escapes text intended to for HTML character data, referencing characters like “&” by their entities, and converting bidirectional controls to HTML elements.
    ///
    /// - Parameters:
    ///     - text: The text to escape.
    @inlinable public static func escapeTextForCharacterData<S>(_ text: S) -> S where S : StringFamily {
        var text = text
        sharedEscape(&text)
        text.scalars.replaceMatches(for: "<".scalars, with: "&#x003C;".scalars)
        text.scalars.replaceMatches(for: "\u{2066}".scalars, with: "<bdi dir=\u{22}ltr\u{22}>".scalars)
        text.scalars.replaceMatches(for: "\u{2067}".scalars, with: "<bdi dir=\u{22}rtl\u{22}>".scalars)
        text.scalars.replaceMatches(for: "\u{2068}".scalars, with: "<bdi dir=\u{22}auto\u{22}>".scalars)
        text.scalars.replaceMatches(for: "\u{2069}".scalars, with: "</bdi>".scalars)
        return text
    }

    /// Escapes text intended to for an attribute value, referencing characters like “&” by their entities.
    ///
    /// - Parameters:
    ///     - text: The text to escape.
    @inlinable public static func escapeTextForAttribute<S>(_ text: S) -> S where S : StringFamily {
        var text = text
        sharedEscape(&text)
        text.scalars.replaceMatches(for: "\u{22}".scalars, with: "&#x0022;".scalars)
        return text
    }

    /// Applies percent encoding to a path intended for a URL.
    ///
    /// - Parameters:
    ///     - path: The path to encode.
    @inlinable public static func percentEncodeURLPath<S>(_ path: S) -> S where S : StringFamily {
        var path = path
        path.scalars.mutateMatches(
            for: ConditionalPattern({ $0.value < 0x80 ∧ $0 ∉ CharacterSet.urlPathAllowed }),
            mutation: { return ("%" + String($0.contents.first!.value, radix: 16)).scalars })
        return path
    }
}
