/*
 Site.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Swift 5.1.5, Web doesn’t have foundation yet; compiler doesn’t recognize os(WASI).)
#if canImport(Foundation)
  import Foundation
#endif

import SDGControlFlow
import SDGLogic
import SDGText
import SDGLocalization

import SDGWebLocalizations
import SDGHTML
import SDGCSS

/// A website.
public struct Site<Localization, Unfolder>
where Localization: SDGLocalization.InputLocalization, Unfolder: SiteSyntaxUnfolder {

  // MARK: - Initialization

  // #workaround(Swift 5.1.5, Web doesn’t have foundation yet; compiler doesn’t recognize os(WASI).)
  #if canImport(Foundation)
    /// Creates a website instance.
    ///
    /// - Parameters:
    ///     - repositoryStructure: The layout of the repository.
    ///     - siteRoot: The base URL where the site will be hosted.
    ///     - localizationDirectories: The name to use for localization directories.
    ///     - siteAuthor: The author of the website.
    ///     - reportProgress: A closure to report progress as the site is assembled.
    ///     - progressReport: A string describing progress made.
    public init(
      repositoryStructure: RepositoryStructure,
      siteRoot: UserFacing<URL, Localization>,
      localizationDirectories: UserFacing<StrictString, Localization>,
      author siteAuthor: UserFacing<ElementSyntax, Localization>,
      reportProgress: @escaping (_ progressReport: StrictString) -> Void
    ) {
      self.repositoryStructure = repositoryStructure
      self.siteRoot = siteRoot
      self.localizationDirectories = localizationDirectories
      self.author = siteAuthor
      self.reportProgress = reportProgress
    }
  #endif

  // MARK: - Properties

  internal let repositoryStructure: RepositoryStructure
  internal let siteRoot: UserFacing<URL, Localization>
  internal let localizationDirectories: UserFacing<StrictString, Localization>
  internal let author: UserFacing<ElementSyntax, Localization>
  internal let reportProgress: (StrictString) -> Void

  // MARK: - Processing

  /// Generates the website in its result directory.
  ///
  /// - Parameters:
  ///     - formatting: Whether the resulting HTML source should be formatted.
  public func generate(formatting: Bool = true) -> Result<Void, SiteGenerationError> {

    clean()

    switch writePages(formatting: formatting) {
    case .failure(let error):
      switch error {
      case .foundationError(let error):  // @exempt(from: tests)
        return .failure(.foundationError(error))
      case .syntaxError(let page, let error):
        return .failure(.syntaxError(page: page, error: error))
      }
    case .success:
      break
    }

    do {
      try copyCSS()
      if FileManager.default.fileExists(atPath: repositoryStructure.resources.path) {
        try copyResources()
      }
    } catch {
      return .failure(.foundationError(error))
    }

    return .success(())
  }

  private func clean() {
    try? FileManager.default.removeItem(at: repositoryStructure.result)
  }

  // #workaround(Swift 5.1.5, Web doesn’t have foundation yet; compiler doesn’t recognize os(WASI).)
  #if canImport(Foundation)
    private func writePages(formatting: Bool) -> Result<Void, PageTemplateLoadingError> {
      let fileEnumeration: [URL]
      do {
        fileEnumeration = try FileManager.default.deepFileEnumeration(in: repositoryStructure.pages)
      } catch {
        return .failure(.foundationError(error))
      }

      for templateLocation in fileEnumeration
      where templateLocation.lastPathComponent ≠ ".DS_Store" {

        switch PageTemplate.load(from: templateLocation, in: self) {
        case .failure(let error):
          return .failure(error)
        case .success(let template):
          for localization in Localization.allCases {
            do {
              try template.writeResult(for: localization, of: self, formatting: formatting)
            } catch {
              return .failure(.foundationError(error))
            }
          }
        }
      }
      return .success(())
    }
  #endif

  private func copyCSS() throws {
    reportProgress(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Copying CSS..."
        case .deutschDeutschland:
          return "Gestaltungsbögen werden kopiert ..."
        }
      }).resolved()
    )
    try FileManager.default.copy(
      repositoryStructure.css,
      to: repositoryStructure.result.appendingPathComponent("CSS")
    )
    try CSS.root.save(
      to: repositoryStructure.result
        .appendingPathComponent("CSS")
        .appendingPathComponent("Root.css")
    )
  }

  private func copyResources() throws {
    reportProgress(
      UserFacing<StrictString, InterfaceLocalization>({ localization in
        switch localization {
        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
          return "Copying resources..."
        case .deutschDeutschland:
          return "Ressourcen werden kopiert ..."
        }
      }).resolved()
    )
    try FileManager.default.copy(
      repositoryStructure.resources,
      to: repositoryStructure.result.appendingPathComponent("Resources")
    )
  }

  // MARK: - Validation

  // #workaround(Swift 5.1.5, Web doesn’t have foundation yet; compiler doesn’t recognize os(WASI).)
  #if canImport(Foundation)
    /// Validates any website.
    ///
    /// - Parameters:
    ///     - site: The URL of a site in the local file system.
    public static func validate(site: URL) -> [URL: [SiteValidationError]] {
      var files: [URL]
      do {
        files = try FileManager.default.deepFileEnumeration(in: site)
      } catch {
        // @exempt(from: tests)
        return [site: [.foundationError(error)]]
      }

      var results: [URL: [SiteValidationError]] = [:]
      for file in files where file.pathExtension == "html" {
        let source: String
        do {
          source = try String(from: file)
        } catch {
          // @exempt(from: tests)
          results[file] = [.foundationError(error)]
          break
        }

        let document = DocumentSyntax.parse(source: source)
        switch document {
        case .failure(let error):
          results[file] = [.syntaxError(error)]
        case .success(let parsed):
          results[file] = parsed.validate(baseURL: file).map { .syntaxError($0) }
        }
      }

      return results.filter { _, value in ¬value.isEmpty }
    }

    /// Validates the generated website.
    public func validate() -> [URL: [SiteValidationError]] {
      return Site.validate(site: repositoryStructure.result)
    }
  #endif
}
