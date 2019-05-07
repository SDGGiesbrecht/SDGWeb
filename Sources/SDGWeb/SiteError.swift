/*
 SiteError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText

import SDGWebLocalizations

/// An error encountered during site generation.
public enum SiteError : PresentableError {

    /// A page has no metadata.
    case noMetadata(page: StrictString)

    /// A metadata entry has no colon separating its key from its value.
    case metadataMissingColon(line: StrictString)

    /// A page has no title.
    case missingTitle(page: StrictString)

    /// An error was encountered while saving a generated page.
    case pageSavingError(page: StrictString, systemError: Swift.Error)

    /// An error was encountered while copying CSS.
    case cssCopyingError(systemError: Swift.Error)

    /// An error was encountered while copying resources.
    case resourceCopyingError(systemError: Swift.Error)

    // MARK: - PresentableError

    public func presentableDescription() -> StrictString {
        return UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch self {
            case .noMetadata(page: let page):
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "“\(page)” has no metadata (“<!\u{2D}\u{2D} ... \u{2D}\u{2D}>”)."
                }
            case .metadataMissingColon(line: let line):
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Metadata entry has no colon:\n\(line)"
                }
            case .missingTitle(page: let page):
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "“\(page)” has no title."
                }
            case .pageSavingError(page: let page, systemError: let error):
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Failed to save page “\(page)”:\n\(error.localizedDescription)"
                }
            case .cssCopyingError(systemError: let error):
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Failed to copy CSS:\n\(error.localizedDescription)"
                }
            case .resourceCopyingError(systemError: let error):
                switch localization {
                case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return "Failed to copy resources:\n\(error.localizedDescription)"
                }
            }
        }).resolved()
    }
}
