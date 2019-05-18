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

    // MARK: - Initialization

    /// Creates an element continuation node.
    ///
    /// - Parameters:
    ///     - content: The content.
    ///     - closingTag: The closing tag.
    public init(content: ContentSyntax, closingTag: ClosingTagSyntax) {
        _storage = _SyntaxStorage(children: [content, closingTag])
    }

    // MARK: - Children

    /// The content of the element.
    public var content: ContentSyntax {
        get {
            return _storage.children[ElementContinuationSyntax.indices[.content]!] as! ContentSyntax
        }
        set {
            _storage.children[ElementContinuationSyntax.indices[.content]!] = newValue
        }
    }

    /// The closing tag.
    public var closingTag: ClosingTagSyntax {
        get {
            return _storage.children[ElementContinuationSyntax.indices[.closingTag]!] as! ClosingTagSyntax
        }
        set {
            _storage.children[ElementContinuationSyntax.indices[.closingTag]!] = newValue
        }
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
