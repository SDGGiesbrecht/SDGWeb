/*
 MockProject.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGText
import SDGLocalization

import SDGHTML
import SDGWeb

import SDGWebLocalizations

import XCTest

func generate<L>(
  forMock mockName: String,
  localization: L.Type,
  expectValidationFailure: Bool = false,
  file: StaticString = #file,
  line: UInt = #line
) throws where L: InputLocalization {

  var sdgWebRepositoryRoot = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
  #if os(Windows)
    var directory = sdgWebRepositoryRoot.path
    if directory.hasPrefix("\u{5C}mnt\u{5C}") {
      directory.removeFirst(5)
      let driveLetter = directory.removeFirst()
      directory.prepend(contentsOf: "\(driveLetter.uppercased()):")
      sdgWebRepositoryRoot = URL(fileURLWithPath: directory)
    }
  #endif
  if let overridden = ProcessInfo.processInfo.environment["SWIFTPM_PACKAGE_ROOT"] {
    sdgWebRepositoryRoot = URL(fileURLWithPath: overridden)
  }

  // @example(readMe🇨🇦EN)
  let mock = RepositoryStructure(
    root:
      sdgWebRepositoryRoot
      .appendingPathComponent("Tests")
      .appendingPathComponent("Mock Projects")
      .appendingPathComponent(mockName)
  )

  let site = Site<L, Unfolder>(
    repositoryStructure: mock,
    siteRoot: UserFacing<URL, L>({ _ in return URL(string: "http://example.com")! }),
    localizationDirectories: UserFacing<StrictString, L>({ localization in
      return localization.icon ?? StrictString(localization.code)
    }),
    author: UserFacing<ElementSyntax, L>({ _ in
      return .author("John Doe", language: InterfaceLocalization.englishCanada)
    }),
    reportProgress: { _ in }
  )

  try site.generate().get()
  let warnings = site.validate()
  // @endExample

  // Test HTML parsing.
  for htmlFile in try FileManager.default.deepFileEnumeration(in: mock.result)
  where htmlFile.pathExtension == "html" {
    let source = try String(from: htmlFile)
    let document = try DocumentSyntax.parse(source: source).get()
    XCTAssertEqual(document.source(), source, file: file, line: line)
  }

  func describe(_ warnings: [URL: [SiteValidationError]]) -> String {
    let files = warnings.keys.sorted()
    return files.map({ url in
      var fileMessage = url.path(relativeTo: mock.result)
      fileMessage.append("\n")
      let errors = warnings[url]!
      fileMessage.append(
        contentsOf: errors.map({ error in
          return error.localizedDescription
        }).joined(separator: "\n")
      )
      return fileMessage
    }).joined(separator: "\n\n")
  }
  if expectValidationFailure {
    XCTAssert(¬warnings.isEmpty, "Expected warnings never triggered.")
  } else {
    XCTAssert(warnings.isEmpty, describe(warnings), file: file, line: line)
  }
}

func expectErrorGenerating<L>(
  forMock mockName: String,
  localization: L.Type,
  file: String = #file,
  line: Int = #line
) where L: InputLocalization {
  do {
    try generate(forMock: mockName, localization: localization)
    XCTFail("Failed to throw error.")
  } catch {}
}
