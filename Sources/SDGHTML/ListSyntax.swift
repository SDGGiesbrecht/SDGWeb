/*
 ListSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A node representing a consecutive list of other nodes.
public struct ListSyntax<Entry> : Syntax
where Entry : Syntax {

    /// Creates a list syntax node from an array of entries.
    public init(entries: [Entry]) {
        _storage = SyntaxStorage(children: entries)
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
