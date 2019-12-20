/*
 TestLocalization.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

import SDGWebLocalizations

struct TestLocalization: InputLocalization {

  // MARK: - Initialization

  init(_ interfaceLocalization: InterfaceLocalization?) {
    self.interfaceLocalization = interfaceLocalization
  }

  // MARK: - Properties

  var interfaceLocalization: InterfaceLocalization?

  // MARK: - CaseIterable

  static var allCases: [TestLocalization] {
    return InterfaceLocalization.allCases.map({ TestLocalization($0) })
      .appending(TestLocalization(nil))
  }

  // MARK: - Localization

  init?(exactly code: String) {
    interfaceLocalization = InterfaceLocalization(exactly: code)
  }

  var code: String {
    return interfaceLocalization?.code ?? "zxx"
  }

  static let fallbackLocalization = TestLocalization(InterfaceLocalization.fallbackLocalization)
}
