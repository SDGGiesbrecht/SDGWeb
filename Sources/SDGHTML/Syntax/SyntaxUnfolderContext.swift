/*
 SyntaxUnfolderContext.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Swift 5.2.2, Web doesn’t have Foundation yet.)
#if !os(WASI)
  import Foundation
#endif

import SDGText
import SDGLocalization

extension SyntaxUnfolder {

  /// Contextual information for a syntax unfolder.
  public struct Context {

    // #workaround(Swift 5.2.2, Web doesn’t have Foundation yet.)
    #if !os(WASI)
      /// Creates a context for a syntax unfolder.
      ///
      /// - Parameters:
      ///   - localization: The target localization.
      ///   - siteRoot: The URL of the site root.
      ///   - relativePath: The location of the page relative to the site root.
      ///   - pageTitle: The title of the page.
      ///   - authorDeclaration: The author declaration.
      ///   - css: The paths of the CSS files to use, each relative to the site root.
      public init<L>(
        localization: L?,
        siteRoot: URL?,
        relativePath: String?,
        title pageTitle: StrictString?,
        author authorDeclaration: ElementSyntax?,
        css: [String]
      )
      where L: Localization {
        self.localization = localization.map { AnyLocalization($0) }
        self.siteRoot = siteRoot
        self.relativePath = relativePath
        self.title = pageTitle
        self.author = authorDeclaration
        self.css = css
      }
    #endif

    // MARK: - Properties

    internal let localization: AnyLocalization?
    // #workaround(Swift 5.2.2, Web doesn’t have Foundation yet.)
    #if !os(WASI)
      internal let siteRoot: URL?
    #endif
    internal let relativePath: String?
    internal let title: StrictString?
    internal let author: ElementSyntax?
    internal let css: [String]
  }
}
