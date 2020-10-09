/*
 ElementSyntax+Factories.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Swift 5.3, Web doesn’t have Foundation yet.)
#if !os(WASI)
  import Foundation
#endif

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
  ///   - language: The language of the author’s name.
  ///   - attributes: Optional. Additional attributes.
  public static func author<L>(
    _ documentAuthor: String,
    language: L,
    attributes: [String: String] = [:]
  ) -> ElementSyntax where L: Localization {
    return metadata(
      value: documentAuthor,
      for: "author",
      attributes: language.htmlAttributes.mergedByOverwriting(from: attributes)
    )
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

  // #workaround(Swift 5.3, Web doesn’t have Foundation yet.)
  #if !os(WASI)
    /// Creates a canonical URL declaration.
    ///
    /// - Parameters:
    ///   - url: The canonical URL.
    ///   - attributes: Optional. Additional attributes.
    public static func canonical(url: URL, attributes: [String: String] = [:]) -> ElementSyntax {
      return ElementSyntax(
        name: "link",
        attributes: [
          "rel": "canonical",
          "href": url.relativeString,
        ].mergedByOverwriting(from: attributes),
        empty: true
      )
    }

    /// Creates a link to external CSS.
    ///
    /// - Parameters:
    ///   - url: The URL of the CSS file.
    ///   - attributes: Optional. Additional attributes.
    public static func css(url: URL, attributes: [String: String] = [:]) -> ElementSyntax {
      return ElementSyntax(
        name: "link",
        attributes: [
          "rel": "stylesheet",
          "href": url.relativeString,
        ].mergedByOverwriting(from: attributes),
        empty: true
      )
    }
  #endif

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
  ///   - language: The language of the document.
  ///   - attributes: Optional. Additional attributes.
  ///   - header: The header.
  ///   - body: The body.
  public static func document<L>(
    language: L,
    attributes: [String: String] = [:],
    header: ElementSyntax,
    body: ElementSyntax
  ) -> ElementSyntax where L: Localization {
    return ElementSyntax(
      name: "html",
      attributes: language.htmlAttributes.mergedByOverwriting(from: attributes),
      contents: [
        .element(header),
        .element(body),
      ]
    )
  }

  /// Creates a document type declaration.
  public static func documentTypeDeclaration() -> ElementSyntax {
    return ElementSyntax(name: "!DOCTYPE", attributes: ["html": ""], empty: true)
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

  /// Creates a footer element (`<footer>`).
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - contents: The contents of the footer.
  public static func footer(
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: "footer", attributes: attributes, contents: contents)
  }

  /// Creates foreign text.
  ///
  /// - Parameters:
  ///   - language: The language of the foreign text.
  ///   - attributes: Optional. Additional attributes.
  ///   - contents: Optional. The foreign text.
  public static func foreignText<L>(
    language: L,
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax where L: Localization {
    var foreign = ElementSyntax(
      name: "foreign",
      attributes: language.htmlAttributes.mergedByOverwriting(from: attributes),
      contents: contents
    )
    SyntaxUnfolder.unfoldForeign(&foreign)
    return foreign
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

  /// Creates a heading (`<h2>`, `<h3>`, etc.).
  ///
  /// Heading levels 1 through 5 correspond to tags `<h2>` to `<h3>`. For the `<h1>` tag, use `title(attributes:contents:)` instead.
  ///
  /// - Parameters:
  ///   - level: The nesting level of the heading.
  ///   - attributes: Optional. The attributes.
  ///   - contents: The contents of the header.
  public static func heading(
    level: HeadingLevel,
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: level.htmlTag, attributes: attributes, contents: contents)
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

  // #workaround(Swift 5.3, Web doesn’t have Foundation yet.)
  #if !os(WASI)
    /// Creates a language switch element.
    ///
    /// - Parameters:
    ///   - attributes: Optional. The attributes.
    ///   - targetURL: The localized target URL.
    public static func languageSwitch<L>(
      attributes: [String: String] = [:],
      targetURL: UserFacing<URL, L>
    ) -> ElementSyntax where L: InputLocalization {
      var entries: ListSyntax<ContentSyntax> = []
      for localization in L.allCases {
        entries.append(
          .element(
            .link(
              target: targetURL.resolved(for: localization),
              language: localization,
              attributes: localization.htmlAttributes,
              contents: [.text(localization.icon.map({ String($0) }) ?? localization.code)]
            )
          )
        )
      }
      return navigation(attributes: attributes, contents: entries)
    }
  #endif

  /// Creates a line break element.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  public static func lineBreak(attributes: [String: String] = [:]) -> ElementSyntax {
    return ElementSyntax(name: "br", attributes: attributes, empty: true)
  }

  // #workaround(Swift 5.3, Web doesn’t have Foundation yet.)
  #if !os(WASI)
    /// Creates a link.
    ///
    /// - Parameters:
    ///   - target: The target URL.
    ///   - language: The language of the target file.
    ///   - attributes: Optional. Additional attributes.
    ///   - contents: Optional. The contents of the link element.
    public static func link<L>(
      target: URL,
      language: L,
      attributes: [String: String] = [:],
      contents: ListSyntax<ContentSyntax> = []
    ) -> ElementSyntax
    where L: Localization {
      return ElementSyntax(
        name: "a",
        attributes: [
          "href": target.relativeString,
          "hreflang": language.code,
        ].mergedByOverwriting(from: attributes),
        contents: contents
      )
    }
  #endif

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
    return .metadata(
      attributes: [
        "name": name,
        "content": value,
      ].mergedByOverwriting(from: attributes)
    )
  }

  /// Creates a metadata header element (`<head>`).
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - encoding: Optional. The encoding.
  ///   - title: The metadata title.
  ///   - canonicalURL: The canonical URL declaration.
  ///   - documentAuthor: The author.
  ///   - description: The description.
  ///   - keywords: The keywords.
  ///   - css: Optional. CSS links.
  ///   - additionalChildren: Optional. Additional children.
  public static func metadataHeader(
    attributes: [String: String] = [:],
    encoding: ElementSyntax = .encoding(),
    title: ElementSyntax,
    canonicalURL: ElementSyntax,
    author documentAuthor: ElementSyntax,
    description: ElementSyntax,
    keywords: ElementSyntax,
    css: [ElementSyntax] = [],
    additionalChildren: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return metadataHeader(
      attributes: attributes,
      encoding: encoding,
      title: title,
      canonicalURL: canonicalURL,
      redirectDestination: nil,
      author: documentAuthor,
      description: description,
      keywords: keywords,
      css: css,
      additionalChildren: additionalChildren
    )
  }
  internal static func metadataHeader(
    attributes: [String: String] = [:],
    encoding: ElementSyntax = .encoding(),
    title: ElementSyntax,
    canonicalURL: ElementSyntax,
    redirectDestination: ElementSyntax?,
    author documentAuthor: ElementSyntax?,
    description: ElementSyntax,
    keywords: ElementSyntax?,
    css: [ElementSyntax] = [],
    additionalChildren: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    var contents: ListSyntax<ContentSyntax> = [
      .element(encoding),
      .element(title),
      .element(canonicalURL),
    ]
    if let redirect = redirectDestination {
      contents.append(.element(redirect))
    }
    if let author = documentAuthor {
      contents.append(.element(author))
    }
    contents.append(.element(description))
    if let keywords = keywords {
      contents.append(.element(keywords))
    }
    contents.append(contentsOf: css.lazy.map({ .element($0) }))
    return ElementSyntax(
      name: "head",
      attributes: attributes,
      contents: contents + additionalChildren
    )
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

  /// Creates an embedded object.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - fallbackRepresentation: The fallback representation of the object.
  public static func object(
    attributes: [String: String] = [:],
    fallbackRepresentation: ListSyntax<ContentSyntax>
  ) -> ElementSyntax {
    return ElementSyntax(name: "object", attributes: attributes, contents: fallbackRepresentation)
  }

  /// Creates a paragraph.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - contents: Optional. The text of the paragraph.
  public static func paragraph(
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: "p", attributes: attributes, contents: contents)
  }

  // #workaround(Swift 5.3, Web doesn’t have Foundation yet.)
  #if !os(WASI)
    /// Creates an embedded portable document (PDF).
    ///
    /// - Parameters:
    ///   - url: The URL of the target document.
    ///   - attributes: Optional. Additional attributes.
    ///   - fallbackRepresentation: Optional. The fallback representation of the document.
    public static func portableDocument(
      url: URL,
      attributes: [String: String] = [:],
      fallbackRepresentation: ListSyntax<ContentSyntax>
    ) -> ElementSyntax {
      return object(
        attributes: [
          "type": "application/pdf",
          "data": url.relativeString,
        ].mergedByOverwriting(from: attributes),
        fallbackRepresentation: fallbackRepresentation
      )
    }

    /// Creates an immediate redirect.
    ///
    /// - Parameters:
    ///   - target: The target of the redirect.
    ///   - attributes: Optional. Additional attributes.
    public static func redirect(target: URL, attributes: [String: String] = [:]) -> ElementSyntax {
      return metadata(
        attributes: [
          "http\u{2D}equiv": "refresh",
          "content": "0; url=\(target.relativeString)",
        ].mergedByOverwriting(from: attributes)
      )
    }
  #endif

  /// Creates a section.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - contents: Optional. The contents of the section.
  public static func section(
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: "section", attributes: attributes, contents: contents)
  }

  /// Creates a span of text.
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - contents: Optional. The contents of the span of text.
  public static func span(
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: "span", attributes: attributes, contents: contents)
  }

  /// Creates a title element (`<h1>`).
  ///
  /// - Parameters:
  ///   - attributes: Optional. The attributes.
  ///   - contents: Optional. The text of the title.
  public static func title(
    attributes: [String: String] = [:],
    contents: ListSyntax<ContentSyntax> = []
  ) -> ElementSyntax {
    return ElementSyntax(name: "h1", attributes: attributes, contents: contents)
  }
}
