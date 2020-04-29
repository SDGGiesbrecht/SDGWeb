/*
 SyntaxUnfolder.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Swift 5.2.2, Web doesn’t have Foundation yet.)
#if !os(WASI)
  import Foundation
#endif

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

  // MARK: - Utilities

  private static func baseURL(fromRelativePath relativePath: String) -> String {
    let nestedLevel = relativePath.components(separatedBy: "/").count − 1
    return String(repeating: "../", count: nestedLevel)
  }

  // MARK: - Individual Unfolding Operations

  /// Removes any redundant language or direction tags that would be inherited anyway.
  ///
  /// - Parameters:
  ///   - document: The document to clean up.
  public static func cleanUpLanguages(_ document: inout DocumentSyntax) {
    for index in document.content.indices {
      let child = document.content[index]
      if case .element(var element) = child.kind {
        var language: String?
        var direction: String?
        cleanUpLanguages(&element, activeLanguage: &language, activeDirection: &direction)
        document.content[index] = .element(element)
      }
    }
  }
  private static func cleanUpLanguages(
    _ element: inout ElementSyntax,
    activeLanguage: inout String?,
    activeDirection: inout String?
  ) {
    func handle(attribute: String, active: inout String?) {
      if let new = element.attribute(named: attribute)?.valueText {
        if new == active {
          element.removeAttribute(named: attribute)
        } else {
          active = new
        }
      }
    }
    handle(attribute: "lang", active: &activeLanguage)
    handle(attribute: "dir", active: &activeDirection)
    for index in element.content.indices {
      let child = element.content[index]
      if case .element(var childElement) = child.kind {
        cleanUpLanguages(
          &childElement,
          activeLanguage: &activeLanguage,
          activeDirection: &activeDirection
        )
        element.content[index] = .element(childElement)
      }
    }
  }

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
    try contentList.mutateEntries { entry in
      guard case .element(let element) = entry.kind,
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
      else {
        return nil
      }
      for child in element.content {
        if case .element(let childElement) = child.kind,
          StrictString(childElement.nameText) == localization.icon
            ∨ childElement.nameText == localization.code
        {
          return childElement.content
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

  public static var _titleAttributeName: UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "title"
      case .deutschDeutschland:
        return "titel"
      }
    })
  }
  // #workaround(Swift 5.2.2, Web doesn’t have Foundation yet.)
  #if !os(WASI)
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
    ///   - authorDeclaration: The author declaration.
    ///   - css: The paths of the CSS files, each relative to the site root.
    public static func unfoldPage<L>(
      _ contentList: inout ListSyntax<ContentSyntax>,
      localization: L,
      siteRoot: URL,
      relativePath: String,
      author authorDeclaration: ElementSyntax,
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
          let title = try page.requiredAttribute(named: _titleAttributeName)
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
                  author: authorDeclaration,
                  description: .description(description),
                  keywords: .keywords(keywords.components(separatedBy: ", ")),
                  css: css.map({ .css(url: URL(fileURLWithPath: baseURL + $0)) })
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
  #endif

  /// Unfolds `<pageTitle>` into the text of the page’s title.
  ///
  /// - Parameters:
  ///   - contentList: The contentList to unfold.
  ///   - title: The page title.
  public static func unfoldPageTitle(
    _ contentList: inout ListSyntax<ContentSyntax>,
    title: StrictString
  ) {
    contentList.mutateEntries { entry in
      guard case .element(let element) = entry.kind,
        element.isNamed(
          UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "pageTitle"
            case .deutschDeutschland:
              return "titel"
            }
          })
        )
      else {
        return nil

      }
      return [ContentSyntax.text(String(title))]
    }
  }

  /// Unfolds `siteReference` and `siteSource` attributes.
  ///
  /// These attributes correspond to the `href` and `src` attributes respectively, but contain a path relative to the site root, instead of the current file. Unfolding will replace them with their corresponding canonical attributes by adjusting the relative path according to the location of the file where the attribute occurs.
  ///
  /// - Parameters:
  ///   - attribute: The attribute to unfold.
  ///   - relativePath: The location of the page relative to the site root.
  public static func unfoldSiteURLAttribute(
    _ attribute: inout AttributeSyntax,
    relativePath: String
  ) {
    let list: [(String, UserFacing<StrictString, InterfaceLocalization>)] = [
      (
        "href",
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "siteReference"
          case .deutschDeutschland:
            return "seitenverweis"
          }
        })
      ),
      (
        "src",
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "siteSource"
          case .deutschDeutschland:
            return "seitenquelle"
          }
        })
      ),
    ]
    for (result, names) in list {
      if attribute.is(named: names),
        var url = attribute.valueText
      {
        attribute.nameText = result
        url.prepend(contentsOf: baseURL(fromRelativePath: relativePath))
        attribute.valueText = url
      }
    }
  }

  // MARK: - SyntaxUnfolderProtocol

  public func unfold(element: inout ElementSyntax) throws {
    SyntaxUnfolder.unfoldForeign(&element)
  }

  public func unfold(attribute: inout AttributeSyntax) throws {
    if let relativePath = context?.relativePath {
      SyntaxUnfolder.unfoldSiteURLAttribute(&attribute, relativePath: relativePath)
    }
  }

  public func unfold(document: inout DocumentSyntax) throws {
    SyntaxUnfolder.cleanUpLanguages(&document)
  }

  public func unfold(contentList: inout ListSyntax<ContentSyntax>) throws {
    if let localization = context?.localization {
      try SyntaxUnfolder.unfoldLocalized(&contentList, localization: localization)
      // #workaround(Swift 5.2.2, Web doesn’t have Foundation yet.)
      #if !os(WASI)
        if let siteRoot = context?.siteRoot,
          let relativePath = context?.relativePath,
          let author = context?.author,
          let css = context?.css
        {
          try SyntaxUnfolder.unfoldPage(
            &contentList,
            localization: localization,
            siteRoot: siteRoot,
            relativePath: relativePath,
            author: author,
            css: css
          )
        }
      #endif
    }
    if let title = context?.title {
      SyntaxUnfolder.unfoldPageTitle(&contentList, title: title)
    }
  }
}
