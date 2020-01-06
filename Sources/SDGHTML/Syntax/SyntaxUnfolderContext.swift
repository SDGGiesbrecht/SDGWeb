/*
 SyntaxUnfolderContext.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLocalization

extension SyntaxUnfolder {

  /// Contextual information for a syntax unfolder.
  public struct Context {

    /// Creates a context for a syntax unfolder.
    ///
    /// - Parameters:
    ///   - localization: The target localization.
    ///   - siteRoot: The URL of the site root.
    ///   - relativePath: The location of the page relative to the site root.
    ///   - author: The author declaration.
    public init<L>(localization: L?, siteRoot: URL?, relativePath: String?, author: ElementSyntax?)
    where L: Localization {
      self.localization = localization.map { AnyLocalization($0) }
      self.siteRoot = siteRoot
      self.relativePath = relativePath
      self.author = author
    }

    // MARK: - Properties

    internal let localization: AnyLocalization?
    internal let siteRoot: URL?
    internal let relativePath: String?
    internal let author: ElementSyntax?
  }
}