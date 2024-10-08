/*
 PageTemplate.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2024 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGMathematics
import SDGCollections
import SDGText
import SDGLocalization

import SDGWebLocalizations
import SDGHTML

internal class PageTemplate<Localization> where Localization: SDGLocalization.InputLocalization {

  // MARK: - Initialization

  #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
    internal static func load<Unfolder>(
      from file: URL,
      in site: Site<Localization, Unfolder>,
      formatting: Bool
    ) -> Result<PageTemplate, PageTemplateLoadingError> {
      let relativePath = StrictString(file.path(relativeTo: site.repositoryStructure.pages))

      let source: StrictString
      do {
        source = try StrictString(from: file)
      } catch {
        return .failure(.foundationError(error))
      }

      let templateSyntax: DocumentSyntax
      switch DocumentSyntax.parse(source: String(source)) {
      case .success(let document):
        templateSyntax = document
        if formatting {
          try? document.formatted().save(to: file)
        }
      case .failure(let error):
        return .failure(.syntaxError(page: relativePath, error: error))
      }

      return .success(
        PageTemplate(
          relativePath: relativePath,
          templateSyntax: templateSyntax
        )
      )
    }
  #endif

  private init(
    relativePath: StrictString,
    templateSyntax: DocumentSyntax
  ) {

    self.relativePath = relativePath
    self.templateSyntax = templateSyntax
  }

  // MARK: - Properties

  private let relativePath: StrictString
  private let templateSyntax: DocumentSyntax

  private func templateAttribute(named name: UserFacing<StrictString, InterfaceLocalization>)
    -> StrictString?
  {
    return templateSyntax.childElements()
      .first(where: { $0.nameText ≠ "!DOCTYPE" })?
      .attribute(named: name)?.valueText
      .map { StrictString($0) }
  }
  private func resolvedTitle() throws -> StrictString {
    if let result = templateAttribute(named: SyntaxUnfolder._titleAttributeName) {
      return result
    } else {
      throw SiteGenerationError.missingTitle(page: relativePath)
    }
  }

  // MARK: - Processing

  private func processedResult<Unfolder>(
    for relativePath: StrictString,
    localization: Localization,
    site: Site<Localization, Unfolder>
  ) throws -> DocumentSyntax {
    var syntax = templateSyntax
    try syntax.unfold(
      with: Unfolder(
        context: SyntaxUnfolder.Context(
          localization: localization,
          siteRoot: site.siteRoot.resolved(for: localization),
          relativePath: String(relativePath),
          title: resolvedTitle(),
          author: site.author.resolved(for: localization),
          css: [
            "CSS/Root.css",
            "CSS/Site.css",
          ]
        )
      )
    )
    return syntax
  }

  // MARK: - Saving

  private func resolvedFileName() throws -> StrictString {
    return try templateAttribute(
      named: UserFacing({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "fileName"
        case .deutschDeutschland:
          return "dateiname"
        }
      })
    ) ?? resolvedTitle()
  }

  #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
    internal func writeResult<Unfolder>(
      for localization: Localization,
      of site: Site<Localization, Unfolder>,
      formatting: Bool
    ) throws {

      var relativePath = self.relativePath
      if Localization.allCases.count > 1 {
        relativePath.prepend(
          contentsOf: site.localizationDirectories.resolved(for: localization) + "/"
        )
      }

      var url = site.repositoryStructure.result.appendingPathComponent(String(relativePath))
      url.deleteLastPathComponent()
      url.appendPathComponent(String(try resolvedFileName()))
      url.appendPathExtension("html")

      let reportedPath = url.path(relativeTo: site.repositoryStructure.result)
      site.reportProgress(
        UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom:
            return "Writing to ‘\(reportedPath)’..."
          case .englishUnitedStates, .englishCanada:
            return "Writing to “\(reportedPath)”..."
          case .deutschDeutschland:
            return "„\(reportedPath)“ wird hergestellt ..."
          }
        }).resolved()
      )

      var result = try processedResult(for: relativePath, localization: localization, site: site)
      if formatting {
        result.format()
      }
      try StrictString(result.source()).save(to: url)
    }
  #endif
}
