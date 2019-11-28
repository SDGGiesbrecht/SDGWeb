/*
 Redirect.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import SDGText

/// An HTML page functioning as a redirect.
///
/// This kind of redirect should only be used as a fallback when the server configuration is unavailable for modification.
public struct Redirect {

  // MARK: - Static Properties

  private static let template: StrictString = {
    var result = StrictString(Resources.redirect)
    let header = result.firstMatch(
      for: "\n\n<!\u{2D}\u{2D}".scalars
        + RepetitionPattern(ConditionalPattern({ $0 ≠ ">" }))
        + "\u{2D}\u{2D}>\n".scalars
    )!
    result.removeSubrange(header.range)
    return result
  }()

  // MARK: - Initialization

  /// Creates a redirect.
  ///
  /// - Parameters:
  ///     - target: The URL to redirect to.
  public init(target: String) {
    var mutable = String(Redirect.template)

    let encoded: String = HTML.escapeTextForAttribute(HTML.percentEncodeURLPath(target))
    mutable.scalars.replaceMatches(for: "[*encoded*]".scalars, with: encoded.scalars)

    let readable = HTML.escapeTextForCharacterData(StrictString(target))
    mutable.scalars.replaceMatches(for: "[*readable*]".scalars, with: readable)

    contents = mutable
  }

  // MARK: - Properties

  /// The source of the HTML file.
  public let contents: String
}
