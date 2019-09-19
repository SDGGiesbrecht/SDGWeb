/*
 ContentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

/// A node representing content.
public struct ContentSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case elements
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    // MARK: - Initialization

    /// Creates content.
    ///
    /// - Parameters:
    ///     - elements: Optional. The distinct elements of content.
    public init(elements: ListSyntax<ContentElementSyntax> = []) {
        _storage = SyntaxStorage(children: [elements])
    }

    // MARK: - Children

    /// The child nodes.
    public var elements: ListSyntax<ContentElementSyntax> {
        get {
            return _storage.children[ContentSyntax.indices[.elements]!] as! ListSyntax<ContentElementSyntax>
        }
        set {
            _storage.children[ContentSyntax.indices[.elements]!] = newValue
        }
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
