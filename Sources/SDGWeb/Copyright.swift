/*
 Copyright.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization
import SDGCalendar

/// Returns the range from the year first published to the present.
///
/// The result will not be expressed as a range if it contains only one year. i.e. “2018” instead of “2018–2018”.
public func copyrightDates(yearFirstPublished: GregorianYear) -> StrictString {
    let now = CalendarDate.gregorianNow().gregorianYear
    if now == yearFirstPublished {
        return yearFirstPublished.inEnglishDigits()
    } else {
        return yearFirstPublished.inEnglishDigits() + "–" + now.inEnglishDigits()
    }
}
