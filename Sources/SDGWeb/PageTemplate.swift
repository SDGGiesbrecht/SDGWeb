/*
 PageTemplate.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

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
        let fileName = StrictString(file.lastPathComponent)
        self.fileName = fileName

        let relativePath = StrictString(file.path(relativeTo: site.repositoryStructure.pages))
        let nestedLevel = relativePath.components(separatedBy: "/").count − 1
        var siteRoot: StrictString = ""
        for _ in 0 ..< nestedLevel {
            siteRoot.append(contentsOf: "../".scalars)
        }
        self.siteRoot = siteRoot

        let source = try PageTemplate.loadSource(from: file, for: relativePath)
        let (metaDataSource, content) = try PageTemplate.extractMetaData(from: source, fileName: fileName, for: relativePath)
        self.content = content
        let metaData = try PageTemplate.parseMetaData(from: metaDataSource)

        guard let title = metaData["Title"] else {
            throw Site<InterfaceLocalization>.Error.missingTitle(page: relativePath)
        }
        self.title = title
    }

    private static func loadSource(from file: URL, for page: StrictString) throws -> StrictString {
        do {
            return try StrictString(from: file)
        } catch {
            throw Site<InterfaceLocalization>.Error.templateLoadingError(page: page, systemError: error)
        }
    }

    private static func extractMetaData(from source: StrictString, fileName: StrictString, for page: StrictString) throws -> (metaDataSource: StrictString, content: StrictString) {

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

    private let fileName: StrictString
    private let siteRoot: StrictString
    private let title: StrictString
    private let content: StrictString

    // MARK: - Processing

    private func processedResult(for relativePath: StrictString, localization: Localization, site: Site<Localization>) -> StrictString {
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
        result.replaceMatches(for: "[*relative path*]", with: StrictString(String(relativePath).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!.scalars))

        result.replaceMatches(for: "[*site root*]".scalars, with: siteRoot)

        result.replaceMatches(for: "[*title*]", with: title)

        result.replaceMatches(for: "[*body*]", with: site.pageProcessor.trimmedFrame())
        site.pageProcessor.process(pageTemplate: &result, title: title, content: content, siteRoot: siteRoot, relativePath: relativePath)

        return result
    }

    // MARK: - Saving

    internal func writeResult(to file: URL, for localization: Localization, of site: Site<Localization>) throws {
        let relativePath = StrictString(file.path(relativeTo: site.repositoryStructure.result))
        site.reportProgress(UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                return StrictString("Writing to “\(relativePath)”...")
            }
        }).resolved())
        do {
            try processedResult(for: relativePath, localization: localization, site: site).save(to: file)
        } catch {
            throw Site<InterfaceLocalization>.Error.pageSavingError(page: relativePath, systemError: error)
        }
    }
}
