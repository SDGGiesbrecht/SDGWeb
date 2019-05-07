/*
 PageTemplate.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGMathematics
import SDGCollections
import SDGText
import SDGLocalization

import SDGWebLocalizations

internal class PageTemplate<Localization> where Localization : SDGLocalization.InputLocalization {

    // MARK: - Initialization

    #warning("Should not throw.")
    internal static func load(from file: URL, in site: Site<Localization>) throws -> Result<PageTemplate, SiteError> {
        let relativePath = StrictString(file.path(relativeTo: site.repositoryStructure.pages))

        let nestedLevel = relativePath.components(separatedBy: "/").count − 1
        var siteRoot: StrictString = ""
        for _ in 0 ..< nestedLevel {
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

        let metaDataExtractionAttempt = PageTemplate.extractMetaData(from: source, for: relativePath)
        let metaDataSource: StrictString
        let content: StrictString
        switch metaDataExtractionAttempt {
        case .failure(let error):
            return .failure(error)
        case .success(let extracted):
            (metaDataSource, content) = extracted
        }

        let metaDataParsingAttempt = PageTemplate.parseMetaData(from: metaDataSource)
        let metaData: [StrictString: StrictString]
        switch metaDataParsingAttempt {
        case .failure(let error):
            return .failure(error)
        case .success(let parsed):
            metaData = parsed
        }

        guard let title = metaData["Title"] else {
            return .failure(SiteError.missingTitle(page: relativePath))
        }

        let fileNameWithoutExtension: StrictString
        if let fileName = metaData["File Name"] {
            fileNameWithoutExtension = fileName
        } else {
            fileNameWithoutExtension = title
        }
        let fileName = fileNameWithoutExtension + ".html"

        return .success(PageTemplate(
            relativePath: relativePath,
            fileName: fileName,
            siteRoot: siteRoot,
            title: title,
            content: content))
    }

    private static func loadSource(from file: URL, for page: StrictString) throws -> StrictString {
        return try StrictString(from: file)
    }

    private static func extractMetaData(from source: StrictString, for page: StrictString) -> Result<(metaDataSource: StrictString, content: StrictString), SiteError> {

        guard let metaDataSegment = source.firstNestingLevel(startingWith: "<!\u{2D}\u{2D}".scalars, endingWith: "\u{2D}\u{2D}>\n".scalars) else {
            return .failure(.noMetadata(page: page))
        }
        let metaData = StrictString(metaDataSegment.contents.contents)

        var content = source
        content.removeSubrange(metaDataSegment.container.range)
        return .success((metaData, content))
    }

    private static func parseMetaData(from source: StrictString) -> Result<[StrictString: StrictString], SiteError> {
        var dictionary: [StrictString: StrictString] = [:]
        for line in source.lines.map({ $0.line }) {
            let withoutIndent = StrictString(line.drop(while: { $0 ∈ CharacterSet.whitespaces }))
            if ¬withoutIndent.isEmpty {
                guard let colon = withoutIndent.firstMatch(for: ": ".scalars) else {
                    return .failure(.metadataMissingColon(line: withoutIndent))
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
        fileName: StrictString,
        siteRoot: StrictString,
        title: StrictString,
        content: StrictString) {

        self.relativePath = relativePath
        self.fileName = fileName
        self.siteRoot = siteRoot
        self.title = title
        self.content = content
    }

    // MARK: - Properties

    private let relativePath: StrictString
    private let fileName: StrictString
    private let siteRoot: StrictString
    private let title: StrictString
    private let content: StrictString

    // MARK: - Processing

    private func processedResult(for relativePath: StrictString, localization: Localization, site: Site<Localization>) throws -> StrictString {
        var result = Frame.frame

        let htmlTextDirection: StrictString
        if let known = localization.textDirection {
            switch known {
            case .rightToLeftTopToBottom, .topToBottomRightToLeft:
                htmlTextDirection = "rtl"
            case .leftToRightTopToBottom:
                htmlTextDirection = "ltr"
            }
        } else {
            htmlTextDirection = "auto"
        }
        result.replaceMatches(for: "[*localization code*]", with: StrictString(localization.code))
        result.replaceMatches(for: "[*text direction*]", with: htmlTextDirection)

        result.replaceMatches(for: "[*domain*]", with: site.domain.resolved(for: localization))
        var localizedRelativePath = StrictString(relativePath)
        if Localization.allCases.count > 1 {
            localizedRelativePath.prepend(contentsOf: site.localizationDirectories.resolved(for: localization) + "/")
        }
        result.replaceMatches(for: "[*relative path*]", with: StrictString(String(localizedRelativePath).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!.scalars))

        result.replaceMatches(for: "[*site root*]".scalars, with: siteRoot)

        var title = self.title
        localize(&title, for: localization)
        result.replaceMatches(for: "[*title*]", with: title)

        result.replaceMatches(for: "[*body*]", with: try site.frame())

        localize(&result, for: localization)

        var localizationRoot = siteRoot
        if Localization.allCases.count > 1 {
            localizationRoot.append(contentsOf: site.localizationDirectories.resolved(for: localization) + "/")
        }

        var content = self.content
        localize(&content, for: localization)
        site.pageProcessor.process(pageTemplate: &result, title: title, content: content, siteRoot: siteRoot, localizationRoot: localizationRoot, relativePath: relativePath)

        return result
    }

    // MARK: - Saving

    internal func writeResult(for localization: Localization, of site: Site<Localization>) throws {
        var relativePath = self.relativePath
        if Localization.allCases.count > 1 {
            relativePath.prepend(contentsOf: site.localizationDirectories.resolved(for: localization) + "/")
        }

        var url = site.repositoryStructure.result.appendingPathComponent(String(relativePath))

        var fileName = self.fileName
        localize(&fileName, for: localization)
        url.deleteLastPathComponent()
        url.appendPathComponent(String(fileName))

        let reportedPath = url.path(relativeTo: site.repositoryStructure.result)
        site.reportProgress(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return "Writing to “\(reportedPath)”..."
            }
        }).resolved())

        do {
            try processedResult(for: relativePath, localization: localization, site: site).save(to: url)
        } catch {
            throw SiteError.pageSavingError(page: relativePath, systemError: error)
        }
    }
}
