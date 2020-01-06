/*
 SyntaxUnfolder.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGMathematics
import SDGText
import SDGLocalization

import SDGWebLocalizations

/// The default `SyntaxUnfolder`.
public struct SyntaxUnfolder: SyntaxUnfolderProtocol {

  // MARK: - Initialization

  /// Creates a syntax unfolder.
  ///
  /// - Parameters:
  ///   - context: Context information for the syntax unfolder. If the context is `nil` or incomplete, the unfolder will ignore the any elements for which it lacks the necessary information to unfold. Examples include `<localized>`, which requires a specified localization, and `<page>` which requires a specified location. The required context information for a particular element can be deduced from the corresponding static `unfold...` method.
  public init(context: Context?) {
    self.context = context
  }

  // MARK: - Properties

  private let context: Context?

  // MARK: - Individual Unfolding Operations

  /// Unfolds `<foreign>` into `<span class="foreign">`.
  ///
  /// `foreign` indicates that a span of text is in a foreign language. Such text is often italicized.
  ///
  /// - Parameters:
  ///   - element: The element to unfold.
  public static func unfoldForeign(_ element: inout ElementSyntax) {
    if element.isNamed(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "foreign"
        case .deutschDeutschland:
          return "fremd"
        }
      })
    ) {
      element.classes.prepend(element.nameText)
      element.nameText = "span"
    }
  }

  /// Unfolds localized elements into the target localization.
  ///
  /// For example, when targeting Canadian English, the following would be unfolded into `This phrase is in English.`
  ///
  /// ```html
  /// <localized>
  ///  <🇨🇦EN>This phrase is in English.</🇨🇦EN>
  ///  <🇫🇷FR>Cette phrase est en français.</🇫🇷FR>
  /// </localized>
  /// ```
  ///
  /// One of the immediate children must match the icon or code of the given localization, otherwise an error will be thrown.
  ///
  /// The `<localized>` element and its untargetted children will be discareded, including any attributes, comments and whitespace. Only the contents of the targeted child will remain.
  ///
  /// - Parameters:
  ///   - contentList: The content list to unfold.
  ///   - localization: The target localization.
  public static func unfoldLocalized<L>(
    _ contentList: inout ListSyntax<ContentSyntax>,
    localization: L
  ) throws
  where L: Localization {
    var finished = false
    passes: while ¬finished {
      for index in contentList.indices {
        let entry = contentList[index]
        if case .element(let element) = entry.kind,
          element.isNamed(
            UserFacing<StrictString, InterfaceLocalization>({ localization in
              switch localization {
              case .englishUnitedKingdom:
                return "localised"
              case .englishUnitedStates, .englishCanada:
                return "localized"
              case .deutschDeutschland:
                return "lokalisiert"
              }
            })
          )
        {
          for child in element.content {
            if case .element(let childElement) = child.kind,
              StrictString(childElement.nameText) == localization.icon
                ∨ childElement.nameText == localization.code
            {
              contentList.replaceSubrange(index...index, with: childElement.content)
              continue passes
            }
          }
          throw UnfoldingError(
            description: UserFacing<StrictString, InterfaceLocalization>({ errorLocalization in
              switch errorLocalization {
              case .englishUnitedKingdom:
                var names = "‘\(localization.code)’"
                if let icon = localization.icon {
                  names = "‘\(icon)’ or \(names)"
                }
                return "A localised element has no child element named \(names)."
              case .englishUnitedStates, .englishCanada:
                var names = "“\(localization.code)”"
                if let icon = localization.icon {
                  names = "“\(icon)” or \(names)"
                }
                return "A localized element has no child element named \(names)."
              case .deutschDeutschland:
                var namen = "„\(localization.code)“"
                if let zeichen = localization.icon {
                  namen = "„\(zeichen)“ oder \(namen)"
                }
                return "Ein lokalisiertes Element hat kein untergeordnetes Element Namens \(namen)."
              }
            }),
            node: element
          )
        }
      }
      finished = true
    }
  }

  private static func baseURL(fromRelativePath relativePath: String) -> URL {
    let nestedLevel = relativePath.components(separatedBy: "/").count − 1
    return URL(fileURLWithPath: String(repeating: "../", count: nestedLevel))
  }

  /// Unfolds the `<page>` element.
  ///
  /// `<page>` serves as the root element of an HTML document. It requires the following attributes:
  ///
  /// - `title` will become the metadata title of the page.
  /// - `description` will become the description of the page.
  /// - `keywords` will become the suggested search keywords for the page.
  ///
  /// The content of the `<page>` element will become the content of the `<body>` element.
  ///
  /// - Parameters:
  ///   - contentList: The content list to unfold.
  ///   - localization: The localization of the page.
  ///   - siteRoot: The URL of the site root.
  ///   - relativePath: The location of the page relative to the site root.
  ///   - css: The paths of the CSS files, each relative to the site root.
  public static func unfoldPage<L>(
    _ contentList: inout ListSyntax<ContentSyntax>,
    localization: L,
    siteRoot: URL,
    relativePath: String,
    author: ElementSyntax,
    css: [String]
  ) throws
  where L: Localization {
    for index in contentList.indices {
      let entry = contentList[index]
      if case .element(let page) = entry.kind,
        page.isNamed(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "page"
            case .deutschDeutschland:
              return "seite"
            }
          })
        )
      {
        let title = try page.requiredAttribute(
          named: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "title"
            case .deutschDeutschland:
              return "titel"
            }
          })
        )
        let description = try page.requiredAttribute(
          named: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "description"
            case .deutschDeutschland:
              return "beschreibung"
            }
          })
        )
        let keywords = try page.requiredAttribute(
          named: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "keywords"
            case .deutschDeutschland:
              return "schlüsselwörter"
            }
          })
        )

        let pageURL = siteRoot.appendingPathComponent(relativePath)
        let baseURL = self.baseURL(fromRelativePath: relativePath)

        contentList.replaceSubrange(
          (index...index).relative(to: contentList),
          with: DocumentSyntax.document(
            documentElement: .document(
              language: localization,
              header: .metadataHeader(
                title: .metadataTitle(title),
                canonicalURL: .canonical(url: pageURL),
                author: author,
                description: .description(description),
                keywords: .keywords(keywords.components(separatedBy: ", ")),
                css: css.map({ .css(url: baseURL.appendingPathComponent($0)) })
              ),
              body: ElementSyntax.body(contents: page.content)
            ),
            formatted: false
          ).content
        )
        return
      }
    }
  }

  // MARK: - SyntaxUnfolderProtocol

  public func unfold(element: inout ElementSyntax) throws {
    SyntaxUnfolder.unfoldForeign(&element)
  }

  public func unfold(contentList: inout ListSyntax<ContentSyntax>) throws {
    if let localization = context?.localization {
      try SyntaxUnfolder.unfoldLocalized(&contentList, localization: localization)
      if let siteRoot = context?.siteRoot,
        let relativePath = context?.relativePath,
        let author = context?.author
      {
        try SyntaxUnfolder.unfoldPage(
          &contentList,
          localization: localization,
          siteRoot: siteRoot,
          relativePath: relativePath,
          author: author,
          css: context?.css ?? []
        )
      }
    }
  }
}
