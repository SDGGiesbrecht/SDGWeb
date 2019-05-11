/*
 DocumentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A syntax node representing an HTML document.
public struct DocumentSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case content
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    /// Parses the source into a syntax tree.
    public static func parse(source: String) -> DocumentSyntax {
        let content = ContentSyntax.parse(source: source)
        return DocumentSyntax(_storage: SyntaxStorage(children: [content]))
    }

    // MARK: - Children

    public let content: ContentSyntax {
        return children[DocumentSyntax.indices[.content]!] as! ContentSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
