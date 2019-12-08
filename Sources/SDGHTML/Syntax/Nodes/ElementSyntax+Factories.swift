/*
 ElementSyntax+Factories.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

extension ElementSyntax {

  /// Creates an article element.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - contents: Optional. The contents of the article.
  public static func article(
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: "article", attributes: attributes, contents: contents)
  }

  /// Creates an author metadata entry.
  ///
  /// - Parameters:
  ///   - documentAuthor: The author.
  ///   - attributes: Optional. Additional attributes.
  public static func author(_ documentAuthor: String, attributes: [String: String] = [:])
    -> ElementSyntax
  {
    return metadata(value: documentAuthor, for: "author", attributes: attributes)
  }

  /// Creates a body element.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - contents: Optional. The contents of the body.
  public static func body(
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: "body", attributes: attributes, contents: contents)
  }

  /// Creates a link to external CSS.
  ///
  /// - Parameters:
  ///   - url: The URL of the CSS file.
  ///   - attributes: Optional. Additional attributes.
  public static func css(url: URL, attributes: [String: String] = [:]) -> ElementSyntax {
    var attributes = attributes
    attributes["href"] = url.relativeString
    attributes["rel"] = "stylesheet"
    return ElementSyntax(name: "link", attributes: attributes, empty: true)
  }

  /// Creates a description metadata entry.
  ///
  /// - Parameters:
  ///   - description: The description.
  ///   - attributes: Optional. Additional attributes.
  public static func description(
    _ description: String,
    attributes: [String: String] = [:]
  ) -> ElementSyntax {
    return metadata(value: description, for: "description", attributes: attributes)
  }

  /// Creates a division.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - contents: Optional. The contents of the division.
  public static func division(
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: "div", attributes: attributes, contents: contents)
  }

  /// Creates an encoding metadata entry.
  ///
  /// - Parameters:
  ///   - encoding: Optional. The encoding. UTF‐8 by default.
  ///   - attributes: Optional. Additional attributes.
  public static func encoding(
    _ encoding: String = "UTF\u{2D}8",
    attributes: [String: String] = [:]
  ) -> ElementSyntax {
    var attributes = attributes
    attributes["charset"] = encoding
    return .metadata(attributes: attributes)
  }

  /// Creates a header element (`<header>`).
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - contents: The contents of the header.
  public static func header(
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: "header", attributes: attributes, contents: contents)
  }

  /// Creates a metadata entry.
  ///
  /// - Parameters:
  ///   - attributes: The attributes.
  public static func metadata(attributes: [String: String]) -> ElementSyntax {
    return ElementSyntax(
      name: "meta",
      attributes: attributes,
      empty: true
    )
  }

  /// Creates a metadata title element (`<title>`).
  ///
  /// - Parameters:
  ///   - attributes: The attributes.
  ///   - title: The title.
  public static func metadataTitle(
    attributes: [String: String] = [:],
    _ title: String
  ) -> ElementSyntax {
    return ElementSyntax(
      name: "title",
      attributes: attributes,
      contents: [
        .text(title)
      ]
    )
  }

  /// Creates a metadata entry.
  ///
  /// - Parameters:
  ///   - value: The value of the metadata entry.
  ///   - name: The name of the metadata entry.
  ///   - attributes: Optional. Additional attributes.
  public static func metadata(
    value: String,
    for name: String,
    attributes: [String: String] = [:]
  ) -> ElementSyntax {
    var attributes = attributes
    attributes["name"] = name
    attributes["content"] = value
    return .metadata(attributes: attributes)
  }
}
