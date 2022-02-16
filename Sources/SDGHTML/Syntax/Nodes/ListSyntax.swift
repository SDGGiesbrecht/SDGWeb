/*
 ListSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2022 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

/// A node representing a consecutive list of other nodes.
public struct ListSyntax<Entry>: ExpressibleByArrayLiteral, MutableCollection,
  RandomAccessCollection, RangeReplaceableCollection, Syntax
where Entry: Syntax {

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

  public mutating func replaceSubrange<S>(_ subrange: Range<Index>, with newElements: S)
  where S: Sequence, S.Element == Entry {
    _storage.children.replaceSubrange(subrange, with: newElements.lazy.map({ $0 }))
  }

  // MARK: - Syntax

  public var _storage: _SyntaxStorage
}
