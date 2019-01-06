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

    internal init(from file: URL, in site: Site<Localization>) throws {
        self.relativePath = StrictString(file.path(relativeTo: site.repositoryStructure.pages))

        let relativePath = StrictString(file.path(relativeTo: site.repositoryStructure.pages))
        let nestedLevel = relativePath.components(separatedBy: "/").count − 1
        var siteRoot: StrictString = ""
        for _ in 0 ..< nestedLevel {
            siteRoot.append(contentsOf: "../".scalars)
        }
        if Localization.allCases.count > 1 {
            siteRoot.append(contentsOf: "../".scalars)
        }
        self.siteRoot = siteRoot

        let source = try PageTemplate.loadSource(from: file, for: relativePath)
        let (metaDataSource, content) = try PageTemplate.extractMetaData(from: source, for: relativePath)
        self.content = content
        let metaData = try PageTemplate.parseMetaData(from: metaDataSource)

        guard let title = metaData["Title"] else {
            throw Site<InterfaceLocalization>.Error.missingTitle(page: relativePath)
        }
        self.title = title

        let fileNameWithoutExtension: StrictString
        if let fileName = metaData["File Name"] {
            fileNameWithoutExtension = fileName
        } else {
            fileNameWithoutExtension = title
        }
        self.fileName = fileNameWithoutExtension + ".html"
    }

    private static func loadSource(from file: URL, for page: StrictString) throws -> StrictString {
        do {
            return try StrictString(from: file)
        } catch {
            throw Site<InterfaceLocalization>.Error.templateLoadingError(page: page, systemError: error)
        }
    }

    private static func extractMetaData(from source: StrictString, for page: StrictString) throws -> (metaDataSource: StrictString, content: StrictString) {

        guard let metaDataSegment = source.firstNestingLevel(startingWith: "<!--".scalars, endingWith: "-->\n".scalars) else {
            throw Site<InterfaceLocalization>.Error.noMetadata(page: page)
        }
        let metaData = StrictString(metaDataSegment.contents.contents)

        var content = source
        content.removeSubrange(metaDataSegment.container.range)
        return (metaData, content)
    }

    private static func parseMetaData(from source: StrictString) throws -> [StrictString: StrictString] {
        var dictionary: [StrictString: StrictString] = [:]
        for line in source.lines.map({ $0.line }) {
            let withoutIndent = StrictString(line.drop(while: { $0 ∈ CharacterSet.whitespaces }))
            if ¬withoutIndent.isEmpty {
                guard let colon = withoutIndent.firstMatch(for: ": ".scalars) else {
                    throw Site<InterfaceLocalization>.Error.metadataMissingColon(line: withoutIndent)
                }
                let key = StrictString(withoutIndent[..<colon.range.lowerBound])
                let value = StrictString(withoutIndent[colon.range.upperBound...])

                dictionary[key] = value
            }
        }
        return dictionary
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
                return StrictString("Writing to “\(reportedPath)”...")
            }
        }).resolved())

        do {
            try processedResult(for: relativePath, localization: localization, site: site).save(to: url)
        } catch {
            throw Site<InterfaceLocalization>.Error.pageSavingError(page: relativePath, systemError: error)
        }
    }
}
