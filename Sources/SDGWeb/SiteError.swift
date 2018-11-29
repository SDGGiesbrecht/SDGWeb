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

    public enum Error : PresentableError {

        case cleaningError(systemError: Swift.Error)
        case frameLoadingError(error: Swift.Error)
        case templateLoadingError(page: StrictString, systemError: Swift.Error)
        case noMetadata(page: StrictString)
        case metadataMissingColon(line: StrictString)
        case missingTitle(page: StrictString)
        case pageSavingError(page: StrictString, systemError: Swift.Error)
        case cssCopyingError(systemError: Swift.Error)

        public func presentableDescription() -> StrictString {
            return UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch self {
                case .cleaningError(systemError: let error):
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Failed to clean (empty) result directory:\n\(error.localizedDescription)")
                    }
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
