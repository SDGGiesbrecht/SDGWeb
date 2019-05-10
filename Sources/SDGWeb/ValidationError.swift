/*
 ValidationError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

import SDGWebLocalizations

internal struct ValidationError : PresentableError {

    // MARK: - Initialization

    internal init(description: UserFacing<[StrictString], InterfaceLocalization>) {
        self.description = description
    }

    // MARK: - Properties

    let description: UserFacing<[StrictString], InterfaceLocalization>

    func presentableDescription() -> StrictString {
        return description.resolved().joined(separator: "\n")
    }
}
