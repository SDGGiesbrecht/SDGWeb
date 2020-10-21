/*
 WindowsTestPatches.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

#if os(Windows)

  import SDGText
  import SDGPersistence
  import SDGLocalization

  // #workaround(SDGCornerstone 6.0.0, Requires newline normalization.)
  func testFileConvertibleConformance<T>(
    of instance: T,
    uniqueTestName: StrictString,
    file: StaticString = #filePath,
    line: UInt = #line
  ) where T: Equatable, T: FileConvertible {}

  // #workaround(SDGCornerstone 6.0.0, Icons lead to segmentation faults.)
  extension Localization {
    var icon: StrictString? {
      return nil
    }
  }
#endif
