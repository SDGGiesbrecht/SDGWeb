/*
 PageProcessor.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText

import SDGHTML

import SDGWebLocalizations

/// A page processor.
public protocol PageProcessor {

  /// Returns the frame to use for each page of the site.
  ///
  /// - Parameters:
  ///     - repositoryStructure: The repository structure to get the frame from.
  func frame(repositoryStructure: RepositoryStructure) throws -> DocumentSyntax

  /// Processes the page template, inserting its components into the frame.
  ///
  /// - Parameters:
  ///     - pageTemplate: The template to process.
  ///     - title: The title of the page.
  ///     - content: The content of the page.
  ///     - siteRoot: The relative path from the page to the site root.
  ///     - localizationRoot: The relative path from the page to the root of its localization.
  ///     - relativePath: The relative path from the site root to the page.
  func process(
    pageTemplate: inout StrictString,
    title: StrictString,
    content: StrictString,
    siteRoot: StrictString,
    localizationRoot: StrictString,
    relativePath: StrictString
  )
}

extension PageProcessor {

  public func frame(repositoryStructure: RepositoryStructure) throws -> DocumentSyntax {
    let source = try StrictString(from: repositoryStructure.frame)
    return try DocumentSyntax.parse(source: String(source)).get()
  }
}
