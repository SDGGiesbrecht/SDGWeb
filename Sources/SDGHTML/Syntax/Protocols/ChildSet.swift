/*
 ChildSet.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020–2024 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

internal protocol ChildSet: CaseIterable, Hashable {}

extension ChildSet {

  internal static func indexTable() -> [Self: Int] {
    var dictionary: [Self: Int] = [:]
    for (index, child) in allCases.enumerated() {
      dictionary[child] = index
    }
    return dictionary
  }
}
