/*
 SiteError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText

import SDGWebLocalizations

extension Site {

    public enum Error : PresentableError {

        case cleaningFailure(Swift.Error)

        public func presentableDescription() -> StrictString {
            return UserFacing<StrictString, InterfaceLocalization>({ localization in
                switch self {
                case .cleaningFailure(let error):
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return StrictString("Failed to clean (empty) result directory:\n\(error)")
                    }
                }
            }).resolved()
        }
    }
}
