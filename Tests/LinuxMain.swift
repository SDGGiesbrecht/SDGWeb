import XCTest

import SDGHTMLTests
import SDGWebTests

var tests = [XCTestCaseEntry]()
tests += SDGHTMLTests.__allTests()
tests += SDGWebTests.__allTests()

XCTMain(tests)
