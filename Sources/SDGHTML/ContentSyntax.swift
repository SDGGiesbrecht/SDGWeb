/*
 ContentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public struct ContentSyntax : Syntax {

    internal static func parse(source: String) -> ContentSyntax {
        return ContentSyntax(_storage: SyntaxStorage(children: [TokenSyntax(kind: .text(source))]))
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
