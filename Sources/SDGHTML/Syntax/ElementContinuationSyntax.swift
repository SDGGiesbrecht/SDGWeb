/*
 ElementContinuationSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// The content and closing tag of an element.
public struct ElementContinuationSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case content
        case closingTag
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal init(content: ContentSyntax, closingTag: ClosingTagSyntax) {
        _storage = _SyntaxStorage(children: [
            content,
            closingTag,
            ])
    }

    // MARK: - Children

    /// The content of the element.
    public var content: ContentSyntax {
        return _storage.children[ElementContinuationSyntax.indices[.content]!] as! ContentSyntax
    }

    /// The closing tag.
    public var closingTag: ClosingTagSyntax {
        return _storage.children[ElementContinuationSyntax.indices[.closingTag]!] as! ClosingTagSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
