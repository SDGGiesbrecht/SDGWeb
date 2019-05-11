/*
 ContentElementSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public struct ContentElementSyntax : Syntax {

    // MARK: - Initialization

    public init(kind: ContentElementSyntaxKind) {
        self.kind = kind
        let child: Syntax
        switch kind {
        case .token(let token):
            child = token
        }
        self._storage = SyntaxStorage(children: [child])
    }

    // MARK: - Properties

    public let kind: ContentElementSyntaxKind

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
