#if !canImport(ObjectiveC)
import XCTest

extension APITests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__APITests = [
        ("testAttribute", testAttribute),
        ("testAttributed", testAttributed),
        ("testAttributes", testAttributes),
        ("testAttributeValue", testAttributeValue),
        ("testClosingTag", testClosingTag),
        ("testComment", testComment),
        ("testDocument", testDocument),
        ("testElement", testElement),
        ("testElementContinuation", testElementContinuation),
        ("testEscaping", testEscaping),
        ("testExampleURL", testExampleURL),
        ("testListSyntax", testListSyntax),
        ("testOpeningTag", testOpeningTag),
        ("testParsing", testParsing),
        ("testPercentEncoding", testPercentEncoding),
        ("testRedirect", testRedirect),
        ("testSyntaxError", testSyntaxError),
        ("testText", testText),
        ("testTextDirection", testTextDirection),
        ("testValidLink", testValidLink),
    ]
}

extension RegressionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__RegressionTests = [
        ("testDataAttributesAllowed", testDataAttributesAllowed),
        ("testValidationOfMultiScalarClusters", testValidationOfMultiScalarClusters),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(APITests.__allTests__APITests),
        testCase(RegressionTests.__allTests__RegressionTests),
    ]
}
#endif
