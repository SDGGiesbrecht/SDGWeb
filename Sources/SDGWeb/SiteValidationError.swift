/*
 SiteValidationError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

import SDGWebLocalizations
import SDGHTML

public enum SiteValidationError : PresentableError {

    // MARK: - Cases

    /// Foundation encountered an error.
    case foundationError(Error)

    /// The file’s syntax could not be parsed.
    case syntaxError(SyntaxError)

    // MARK: - Properties

    public func presentableDescription() -> StrictString {
        switch self {
        case .foundationError(let error):
            return StrictString(error.localizedDescription)
        case .syntaxError(let error):
            return error.presentableDescription()
        }
    }
}
