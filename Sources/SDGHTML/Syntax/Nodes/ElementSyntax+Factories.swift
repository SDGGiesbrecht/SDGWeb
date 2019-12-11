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

import SDGLocalization

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

  /// Creates a document element (`<html>`).
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - header: The header.
  ///   - body: The body.
  public static func document(
    attributes: [String: String] = [:],
    header: ElementSyntax,
    body: ElementSyntax
  ) -> ElementSyntax {
    return ElementSyntax(
      name: "html",
      attributes: attributes,
      contents: [
        .element(header),
        .element(body),
      ]
    ).formatted()
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

  /// Creates a keywords metadata entry.
  ///
  /// - Parameters:
  ///   - keywords: The keywords.
  ///   - attributes: Optional. Additional attributes.
  public static func keywords(
    _ keywords: [String],
    attributes: [String: String] = [:]
  ) -> ElementSyntax {
    return metadata(
      value: keywords.joined(separator: ", "),
      for: "keywords",
      attributes: attributes
    )
  }

  /// Creates a line break element.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  public static func lineBreak(attributes: [String: String] = [:]) -> ElementSyntax {
    return ElementSyntax(name: "br", attributes: attributes, empty: true)
  }

  /// Creates a link.
  ///
  /// - Parameters:
  ///   - target: The targe URL.
  ///   - attributes: Optional. Additional attributes.
  public static func link<L>(
    target: URL,
    language: L,
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax
    where L: Localization {
    var attributes = attributes
    attributes["href"] = target.relativeString
    attributes["hreflang"] = language.code
    return ElementSyntax(name: "a", attributes: attributes, contents: contents)
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

  /// Creates a metadata header element (`<head>`).
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - encoding: Optional. The encoding.
  ///   - title: The metadata title.
  ///   - description: The description.
  ///   - keywords: The keywords.
  ///   - documentAuthor: The author.
  ///   - css: Optional. CSS links.
  ///   - additionalChildren: Optional. Additional children.
  public static func metadataHeader(
    attributes: [String: String] = [:],
    encoding: ElementSyntax = .encoding(),
    title: ElementSyntax,
    description: ElementSyntax,
    keywords: ElementSyntax,
    author documentAuthor: ElementSyntax,
    css: [ElementSyntax] = [],
    additionalChildren: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(
      name: "head",
      attributes: attributes,
      contents: [
        .element(encoding),
        .element(title),
        .element(description),
        .element(keywords),
        .element(documentAuthor),
      ] + additionalChildren
    ).formatted()
  }

  /// Creates a metadata title element (`<title>`).
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
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

  /// Creates a navigation element.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - contents: Optional. The contents of the body.
  public static func navigation(
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: "nav", attributes: attributes, contents: contents)
  }
}
