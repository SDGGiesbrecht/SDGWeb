/*
 SiteError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText

import SDGWebLocalizations

extension Site {

    /// An error encountered during site generation.
    public enum Error : PresentableError {

        /// An error was encountered while loading the frame.
        case frameLoadingError(error: Swift.Error)

        /// An error was encountered while loading a template file.
        case templateLoadingError(page: StrictString, systemError: Swift.Error)

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

        // #documentation(SDGCornerstone.PresentableError.presentableDescription())
        /// Returns a localized description of the error.
        public func presentableDescription() -> StrictString {
            return UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch self {
                case .frameLoadingError(error: let error):
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Error loading frame:\n\(error.localizedDescription)")
                    }
                case .templateLoadingError(page: let page, systemError: let error):
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Failed to load template page “\(page)”:\n\(error.localizedDescription)")
                    }
                case .noMetadata(page: let page):
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("“\(page)” has no metadata (“<!-- ... -->”).")
                    }
                case .metadataMissingColon(line: let line):
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Metadata entry has no colon:\n\(line)")
                    }
                case .missingTitle(page: let page):
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("“\(page)” has no title.")
                    }
                case .pageSavingError(page: let page, systemError: let error):
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Failed to save page “\(page)”:\n\(error)")
                    }
                case .cssCopyingError(systemError: let error):
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Failed to copy CSS:\n\(error)")
                    }
                }
            }).resolved()
        }
    }
}
