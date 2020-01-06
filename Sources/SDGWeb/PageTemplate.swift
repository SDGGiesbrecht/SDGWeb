/*
 PageTemplate.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

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

  internal static func load(from file: URL, in site: Site<Localization>) -> Result<
    PageTemplate, PageTemplateLoadingError
  > {
    let relativePath = StrictString(file.path(relativeTo: site.repositoryStructure.pages))

    let nestedLevel = relativePath.components(separatedBy: "/").count − 1
    var siteRoot: StrictString = ""
    for _ in 0..<nestedLevel {
      siteRoot.append(contentsOf: "../".scalars)
    }
    if Localization.allCases.count > 1 {
      siteRoot.append(contentsOf: "../".scalars)
    }

    let source: StrictString
    do {
      source = try PageTemplate.loadSource(from: file, for: relativePath)
    } catch {
      return .failure(.foundationError(error))
    }

    let metaDataSource: StrictString
    let content: StrictString
    switch PageTemplate.extractMetaData(from: source, for: relativePath) {
    case .failure(let error):
      return .failure(.metaDataExtractionError(error))
    case .success(let extracted):
      (metaDataSource, content) = extracted
    }

    let metaData: [StrictString: StrictString]
    switch PageTemplate.parseMetaData(from: metaDataSource) {
    case .failure(let error):
      return .failure(.metaDataParsingError(error))
    case .success(let parsed):
      metaData = parsed
    }

    let fileName = metaData["File Name"]

    let templateSyntax: DocumentSyntax
    switch DocumentSyntax.parse(source: String(content)) {
    case .success(let document):
      templateSyntax = document
    case .failure(let error):
      return .failure(.syntaxError(page: relativePath, error: error))
    }

    return .success(
      PageTemplate(
        relativePath: relativePath,
        fileName: fileName,
        siteRoot: siteRoot,
        templateSyntax: templateSyntax
      )
    )
  }

  private static func loadSource(from file: URL, for page: StrictString) throws -> StrictString {
    return try StrictString(from: file)
  }

  private static func extractMetaData(from source: StrictString, for page: StrictString) -> Result<
    (metaDataSource: StrictString, content: StrictString), PageTemplateMetaDataExtractionError
  > {

    guard
      let metaDataSegment = source.firstNestingLevel(
        startingWith: "<!\u{2D}\u{2D}".scalars,
        endingWith: "\u{2D}\u{2D}>\n".scalars
      )
    else {
      return .failure(PageTemplateMetaDataExtractionError(page: page))
    }
    let metaData = StrictString(metaDataSegment.contents.contents)

    var content = source
    content.removeSubrange(metaDataSegment.container.range)
    return .success((metaData, content))
  }

  private static func parseMetaData(from source: StrictString) -> Result<
    [StrictString: StrictString], PageTemplateMetaDataParsingError
  > {
    var dictionary: [StrictString: StrictString] = [:]
    for line in source.lines.map({ $0.line }) {
      let withoutIndent = StrictString(line.drop(while: { $0 ∈ CharacterSet.whitespaces }))
      if ¬withoutIndent.isEmpty {
        guard let colon = withoutIndent.firstMatch(for: ": ".scalars) else {
          return .failure(PageTemplateMetaDataParsingError(line: withoutIndent))
        }
        let key = StrictString(withoutIndent[..<colon.range.lowerBound])
        let value = StrictString(withoutIndent[colon.range.upperBound...])

        dictionary[key] = value
      }
    }
    return .success(dictionary)
  }

  private init(
    relativePath: StrictString,
    fileName: StrictString?,
    siteRoot: StrictString,
    templateSyntax: DocumentSyntax
  ) {

    self.relativePath = relativePath
    self.fileName = fileName
    self.siteRoot = siteRoot
    self.templateSyntax = templateSyntax
  }

  // MARK: - Properties

  private let relativePath: StrictString
  private let fileName: StrictString?
  private let siteRoot: StrictString
  private let templateSyntax: DocumentSyntax

  // MARK: - Processing

  private func processedResult(
    for relativePath: StrictString,
    localization: Localization,
    site: Site<Localization>
  ) throws -> DocumentSyntax {

    let siteRoot = site.siteRoot.resolved(for: localization)

    var result = StrictString(
      DocumentSyntax.document(
        documentElement: .document(
          language: localization,
          header: .metadataHeader(
            title: .span(),
            canonicalURL: .span(),
            author: .span(),
            description: .span(),
            keywords: .span(),
            css: [
              .css(url: URL(fileURLWithPath: "\(siteRoot)CSS/Root.css")),
              .css(url: URL(fileURLWithPath: "\(siteRoot)CSS/Site.css"))
            ]
          ),
          body: .body(contents: [])
        )
      ).source()
    )

    var localizationRoot = self.siteRoot
    if Localization.allCases.count > 1 {
      localizationRoot.append(
        contentsOf: site.localizationDirectories.resolved(for: localization) + "/"
      )
    }

    let unused = (siteRoot, localizationRoot, relativePath)

    var syntax = templateSyntax
    try syntax.unfold(
      with: site.pageProcessor.syntaxUnfolder(
        localization: localization,
        siteRoot: siteRoot,
        relativePath: String(relativePath),
        author: site.author.resolved(for: localization),
        css: [
          "CSS/Root.css",
          "CSS/Site.css"
        ]
      )
    )
    return syntax
  }

  private func url(domain: StrictString, path: StrictString) throws -> URL {
    guard var components = URLComponents(string: String(domain)) else {
      // @exempt(from: tests) Not sure how to trigger.
      throw SiteGenerationError.invalidDomain(domain)
    }
    components.path = "/" + String(path)
    guard let result = components.url else {
      // @exempt(from: tests) Not sure how to trigger.
      throw SiteGenerationError.invalidDomain(domain)
    }
    return result
  }

  // MARK: - Saving

  private func resolvedFileName() throws -> StrictString {
    if let overridden = fileName {
      return overridden
    } else if let declared = templateSyntax.childElements()
      .first(where: { $0.nameText ≠ "!DOCTYPE" })?.attribute(
        named: UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
            return "title"
          case .deutschDeutschland:
            return "Titel"
          }
        })
      )?.valueText
    {
      return StrictString(declared)
    } else {
      throw SiteGenerationError.missingTitle(page: relativePath)
    }
  }

  internal func writeResult(
    for localization: Localization,
    of site: Site<Localization>,
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
}
