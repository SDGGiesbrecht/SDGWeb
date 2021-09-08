/*
 OpeningTagSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2021 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic

/// An opening tag.
public struct OpeningTagSyntax: AttributedSyntax, NamedSyntax, Syntax {

  // MARK: - Parsing

  private enum Child: ChildSet {
    case lessThan
    case name
    case attributes
    case greaterThan
  }
  private static let indices = Child.indexTable()

  // MARK: - Initialization

  /// Creates an opening tag.
  ///
  /// - Parameters:
  ///     - lessThan: The less‐than sign. (Supplied automatically if omitted.)
  ///     - name: The tag name.
  ///     - attributes: Optional. Any attributes.
  ///     - greaterThan: The greater‐than sign. (Supplied automatically if omitted.)
  public init(
    lessThan: TokenSyntax = TokenSyntax(kind: .lessThan),
    name: TokenSyntax,
    attributes: AttributesSyntax? = nil,
    greaterThan: TokenSyntax = TokenSyntax(kind: .greaterThan)
  ) {
    _storage = _SyntaxStorage(children: [lessThan, name, attributes, greaterThan])
  }

  /// Creates an opening tag.
  ///
  /// - Parameters:
  ///     - name: The tag name.
  ///     - attributes: Optional. The attributes.
  public init(name: TokenKind, attributes: AttributesSyntax? = nil) {
    self.init(name: TokenSyntax(kind: name), attributes: attributes)
  }

  /// Creates an opening tag.
  ///
  /// - Parameters:
  ///     - name: The tag name.
  ///     - attributes: Optional. The attributes.
  public init(name: String, attributes: [String: String] = [:]) {
    self.init(name: .elementName(name), attributes: AttributesSyntax(dictionary: attributes))
  }

  // MARK: - Children

  /// The less‐than sign.
  public var lessThan: TokenSyntax {
    get {
      return _storage.children[OpeningTagSyntax.indices[.lessThan]!] as! TokenSyntax
    }
    set {
      _storage.children[OpeningTagSyntax.indices[.lessThan]!] = newValue
    }
  }

  /// The tag name.
  public var name: TokenSyntax {
    get {
      return _storage.children[OpeningTagSyntax.indices[.name]!] as! TokenSyntax
    }
    set {
      _storage.children[OpeningTagSyntax.indices[.name]!] = newValue
    }
  }

  /// Any attributes.
  public var attributes: AttributesSyntax? {
    get {
      return _storage.children[OpeningTagSyntax.indices[.attributes]!] as? AttributesSyntax
    }
    set {
      _storage.children[OpeningTagSyntax.indices[.attributes]!] = newValue
    }
  }

  /// The greater‐than sign.
  public var greaterThan: TokenSyntax {
    get {
      return _storage.children[OpeningTagSyntax.indices[.greaterThan]!] as! TokenSyntax
    }
    set {
      _storage.children[OpeningTagSyntax.indices[.greaterThan]!] = newValue
    }
  }

  // MARK: - Validation

  internal func validate(
    location: String.ScalarView.Index,
    file: String,
    baseURL: URL
  ) -> [SyntaxError] {
    var results: [SyntaxError] = []
    validateURLValues(
      location: location,
      file: file,
      baseURL: baseURL,
      results: &results
    )
    return results
  }

  private func validateURLValues(
    location: String.ScalarView.Index,
    file: String,
    baseURL: URL,
    results: inout [SyntaxError]
  ) {
    if let attributes = self.attributes?.attributes {
      if name.source() == "link",
        attributes.contains(where: { attribute in
          attribute.name.source() == "rel" ∧ attribute.value?.value.source() == "canonical"
        })
      {
        // Skip
      } else {
        for attribute in attributes {
          attribute.validateURLValue(
            location: location,
            file: file,
            baseURL: baseURL,
            results: &results
          )
        }
      }
    }
  }

  // MARK: - AttributedSyntax

  public var attributeDictionary: [String: String] {
    get {
      return attributes?.attributeDictionary ?? [:]
    }
    set {
      attributes = AttributesSyntax(dictionary: newValue)
    }
  }

  public func attribute(named name: String) -> AttributeSyntax? {
    return attributes?.attribute(named: name)
  }

  public mutating func apply(attribute: AttributeSyntax) {
    if attributes == nil {
      attributes = []
    }
    attributes?.apply(attribute: attribute)
  }

  public mutating func removeAttribute(named name: String) {
    attributes?.removeAttribute(named: name)
    if attributes?.attributes?.isEmpty ≠ false {
      attributes = nil
    }
  }

  // MARK: - NamedSyntax

  public static func nameTokenKind(_ text: String) -> TokenKind {
    return .elementName(text)
  }

  // MARK: - Syntax

  public var _storage: _SyntaxStorage
}
