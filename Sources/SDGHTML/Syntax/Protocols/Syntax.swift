/*
 Syntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGControlFlow

/// A Syntax node.
public protocol Syntax : TransparentWrapper, TextOutputStreamable {
    var _storage: _SyntaxStorage { get set }

    /// Applies systematic formatting to the HTML source node.
    mutating func format()
}

extension Syntax {

    /// The source of this node.
    public func source() -> String {
        var result = ""
        write(to: &result)
        return result
    }

    /// The children of this node.
    public var children: [Syntax] {
        return _storage.children.compactMap { $0 }
    }

    /// All the desendend nodes, at all nesting levels (including the node itself).
    public func descendents() -> [Syntax] {
        return children.lazy.flatMap({ $0.descendents() }).prepending(self)
    }

    public mutating func format() {
        for index in _storage.children.indices {
            _storage.children[index]?.format()
        }
    }

    /// Returns the HTML node with systematic formatting applied to its source.
    public func formatted() -> Self {
        return nonmutatingVariant(of: { $0.format() }, on: self)
    }

    // MARK: - TextOutputStreamable

    public func write<Target>(to target: inout Target) where Target : TextOutputStream {
        if case let token as TokenSyntax = self {
            token.tokenKind.text.write(to: &target)
        } else {
            for child in children {
                child.write(to: &target)
            }
        }
    }

    // MARK: - TransparentWrapper

    public var wrappedInstance: Any {
        return source()
    }
}
