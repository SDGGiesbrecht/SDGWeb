/*
 ContentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A child node of a content section.
public struct ContentSyntax : Syntax {

    // MARK: - Initialization

    /// Creates a content element node.
    ///
    /// - Parameters:
    ///     - kind: The kind of node.
    public init(kind: ContentSyntaxKind) {
        self.kind = kind
        let child: Syntax
        switch kind {
        case .text(let text):
            child = text
        case .element(let element):
            child = element
        case .comment(let comment):
            child = comment
        }
        self._storage = SyntaxStorage(children: [child])
    }

    // MARK: - Properties

    /// The kind of node.
    public let kind: ContentSyntaxKind

    // MARK: - Formatting

    /// Only affects text; other kinds will do nothing.
    internal mutating func setLeadingWhitespace(to whitespace: String) {
        #warning("Not implemented yet.")
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
