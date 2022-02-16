/*
 HTML.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2022 Jeremy David Giesbrecht and the SDGWeb project contributors.

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

  @inlinable internal static func sharedEscape<S>(_ text: inout S) where S: StringFamily {
    text.scalars.replaceMatches(for: "&".scalars, with: "&#x0026;".scalars)
  }
  @inlinable internal static func sharedUnescape<S>(_ text: inout S) where S: StringFamily {
    text.scalars.mutateMatches(
      for: "&".scalars + RepetitionPattern(¬";".scalars) + ";".scalars,
      mutation: { (match: PatternMatch<S.ScalarView>) -> S.ScalarView.SubSequence in
        var entity = match.contents
        entity.removeFirst()
        entity.removeLast()
        if let text = entities[String(String.ScalarView(entity))] {
          return S.ScalarView(text.scalars)[...]
        } else if entity.first == "#",
          entity.dropFirst().allSatisfy({ $0.properties.isHexDigit }),
          let hexadecimal = UInt32(String(String.ScalarView(entity)).dropFirst(), radix: 16),
          let scalar = Unicode.Scalar.init(hexadecimal)
        {
          return S.ScalarView(String(scalar).scalars)[...]
        } else if entity.allSatisfy({ $0.properties.isASCIIHexDigit }),
          let decimal = UInt32(String(String.ScalarView(entity)), radix: 10),
          let scalar = Unicode.Scalar.init(decimal)
        {
          return S.ScalarView(String(scalar).scalars)[...]
        }
        return match.contents
      }
    )
  }

  /// Escapes text intended to for HTML character data, referencing characters like “&” by their entities, and converting bidirectional controls to HTML elements.
  ///
  /// - Parameters:
  ///     - text: The text to escape.
  @inlinable public static func escapeTextForCharacterData<S>(_ text: S) -> S
  where S: StringFamily {
    var text = text
    sharedEscape(&text)
    text.scalars.replaceMatches(for: "<".scalars, with: "&#x003C;".scalars)
    text.scalars.replaceMatches(for: ">".scalars, with: "&#x003E;".scalars)
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
  @inlinable public static func escapeTextForAttribute<S>(_ text: S) -> S where S: StringFamily {
    var text = text
    sharedEscape(&text)
    text.scalars.replaceMatches(for: "\u{22}".scalars, with: "&#x0022;".scalars)
    return text
  }
  /// Unescapes text from an attribute value, resolving entities.
  ///
  /// - Parameters:
  ///     - text: The text to escape.
  @inlinable internal static func unescapeTextForAttribute<S>(_ text: S) -> S
  where S: StringFamily {
    var text = text
    text.scalars.replaceMatches(for: "&#x0022;".scalars, with: "\u{22}".scalars)
    sharedUnescape(&text)
    return text
  }

  /// Applies percent encoding to a path intended for a URL.
  ///
  /// - Parameters:
  ///     - path: The path to encode.
  @inlinable public static func percentEncodeURLPath<S>(_ path: S) -> S where S: StringFamily {
    var path = path
    path.scalars.mutateMatches(
      for: ConditionalPattern({ $0.value < 0x80 ∧ $0 ∉ CharacterSet.urlPathAllowed }),
      mutation: { return ("%" + String($0.contents.first!.value, radix: 16)).scalars }
    )
    return path
  }
}
