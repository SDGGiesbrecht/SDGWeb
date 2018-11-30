/*
 MockProject.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLocalization
import SDGWeb

import XCTest

func generate<L>(forMock mockName: String, localization: L.Type) throws where L : InputLocalization {
    let mock = RepositoryStructure(root: URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("Mock Projects/\(mockName)"))
    let site = Site<L>(
        repositoryStructure: mock,
        domain: UserFacing<StrictString, L>({ _ in return "http://example.com" }),
        localizationDirectories: UserFacing<StrictString, L>({ localization in return localization.icon ?? StrictString(localization.code) }),
        pageProcessor: Processor(),
        reportProgress: { _ in })
    try site.generate()
}

func expectErrorGenerating<L>(forMock mockName: String, localization: L.Type, file: String = #file, line: Int = #line) where L : InputLocalization {
    do {
        try generate(forMock: mockName, localization: localization)
        XCTFail("Failed to throw error.")
    } catch {}
}
