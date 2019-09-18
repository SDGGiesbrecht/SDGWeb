/*
 ListSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

/// A node representing a consecutive list of other nodes.
public struct ListSyntax<Entry> : ExpressibleByArrayLiteral, MutableCollection, RandomAccessCollection, RangeReplaceableCollection, Syntax
where Entry : Syntax {

    /// Creates a list syntax node from an array of entries.
    ///
    /// - Parameters:
    ///     - entries: The entries.
    public init(entries: [Entry]) {
        _storage = SyntaxStorage(children: entries)
    }

    // MARK: - BidirectionalCollection

    public func index(before i: Index) -> Index {
        return _storage.children.index(before: i)
    }

    // MARK: - Collection

    public typealias Index = Array<Entry>.Index

    public var startIndex: Index {
        return _storage.children.startIndex
    }

    public var endIndex: Index {
        return _storage.children.endIndex
    }

    public func index(after i: Index) -> Index {
        return _storage.children.index(after: i)
    }

    public subscript(position: Index) -> Entry {
        get {
            return _storage.children[position] as! Entry
        }
        set {
            _storage.children[position] = newValue
        }
    }

    // MARK: - RandomAccessCollection

    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        return _storage.children.index(i, offsetBy: distance)
    }

    // MARK: - RangeReplaceableCollection

    public init() {
        self.init(entries: [])
    }

    public mutating func replaceSubrange<S>(_ subrange: Range<Index>, with newElements: S) where S : Sequence, S.Element == Entry {
        _storage.children.replaceSubrange(subrange, with: newElements.lazy.map({ $0 }))
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}

extension ListSyntax : AttributedSyntax where Entry == AttributeSyntax {

    private mutating func append(from dictionary: [String: String]) {
        for key in dictionary.keys.sorted() {
            let value = dictionary[key]
            append(AttributeSyntax(name: key, value: value))
        }
    }

    /// Creates an attribute list from a dictionary.
    ///
    /// - Parameters:
    ///     - dictionary: The attributes in dictionary form.
    public init?(dictionary: [String: String]) {
        guard ¬dictionary.isEmpty else {
            return nil
        }
        self.init()
        append(from: dictionary)
    }

    // MARK: - AttributedSyntax

    public var attributeDictionary: [String: String] {
        get {
            var result: [String: String] = [:]
            for attribute in self {
                result[attribute.nameText] = attribute.valueText ?? ""
            }
            return result
        }
        set {
            self = ListSyntax<AttributeSyntax>()
            append(from: newValue)
        }
    }

    public func attribute(named name: String) -> AttributeSyntax? {
        return first(where: { $0.nameText == name })
    }

    public mutating func apply(attribute: AttributeSyntax) {
        let name = attribute.nameText
        if let index = indices.first(where: { self[$0].nameText == name }) {
            self[index] = attribute
        } else {
            append(attribute)
        }
    }
}
