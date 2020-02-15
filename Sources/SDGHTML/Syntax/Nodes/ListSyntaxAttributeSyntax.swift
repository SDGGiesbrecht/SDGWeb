/*
 ListSyntaxAttributeSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

extension ListSyntax: AttributedSyntax where Entry == AttributeSyntax {

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

  // MARK: - Formatting

  internal mutating func formatAttributeList(indentationLevel: Int) {
    format(indentationLevel: indentationLevel)
    sort(by: { $0.nameText < $1.nameText })
  }

  internal mutating func setAllLeadingWhitespace(to whitespace: String) {
    for index in self.indices {
      self[index].whitespace = TokenSyntax(kind: .whitespace(whitespace))
    }
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

  public mutating func removeAttribute(named name: String) {
    if let index = indices.first(where: { self[$0].nameText == name }) {
      remove(at: index)
    }
  }
}
