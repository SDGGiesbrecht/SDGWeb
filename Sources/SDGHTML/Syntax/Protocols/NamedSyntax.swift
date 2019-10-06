/*
 NamedSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A node which has a single associated name.
public protocol NamedSyntax : Syntax {

    /// Creates the appropriate token kind containing the provided text.
    static func nameTokenKind(_ text: String) -> TokenKind

    /// The name token.
    var name: TokenSyntax { get set }
}

extension NamedSyntax {

    /// The name text.
    public var nameText: String {
        get {
            return name.tokenKind.text
        }
        set {
            name.tokenKind = Self.nameTokenKind(newValue)
        }
    }
}
