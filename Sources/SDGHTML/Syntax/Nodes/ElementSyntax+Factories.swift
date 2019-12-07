/*
 ElementSyntax+Factories.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension ElementSyntax {

  /// Creates an article element.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  public static func article(attributes: [String: String] = [:]) -> ElementSyntax {
    return ElementSyntax(name: "article", attributes: attributes, empty: false)
  }

  /// Creates an author metadata entry.
  ///
  /// - Parameters:
  ///   - author: The author.
  ///   - attributes: Optional. Additional attributes.
  public static func author(_ author: String, attributes: [String: String] = [:]) -> ElementSyntax {
    return metadata(value: author, for: "author", attributes: attributes)
  }

  /// Creates a metadata entry.
  ///
  /// - Parameters:
  ///   - value: The value of the metadata entry.
  ///   - name: The name of the metadata entry.
  ///   - attributes: Optional. Additional attributes.
  public static func metadata(value: String, for name: String, attributes: [String: String] = [:])
    -> ElementSyntax
  {
    var attributes = attributes
    attributes["name"] = name
    attributes["content"] = value
    return ElementSyntax(
      name: "meta",
      attributes: attributes,
      empty: true
    )
  }
}
