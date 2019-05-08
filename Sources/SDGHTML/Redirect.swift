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
import SDGText

/// An HTML page functioning as a redirect.
///
/// This kind of redirect should only be used as a fallback when the server configuration is unavailable for modification.
public struct Redirect {

    // MARK: - Static Properties

    private static let template: StrictString = {
        var result = StrictString(Resources.redirect)
        let header = result.firstMatch(for: CompositePattern<Unicode.Scalar>([
            LiteralPattern("\n\n<!--".scalars),
            RepetitionPattern(ConditionalPattern({ $0 ≠ ">" })),
            LiteralPattern("\u{2D}\u{2D}>\n".scalars)
            ]))!
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
        mutable.scalars.replaceMatches(for: "[*target*]".scalars, with: HTML.percentEncodeURLPath(HTML.escapeTextForAttribute(target)).scalars)
        contents = mutable
    }

    // MARK: - Properties

    /// The source of the HTML file.
    public let contents: String
}
