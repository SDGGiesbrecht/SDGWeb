/*
 SDGHTMLAPITests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGLocalization

import SDGWebLocalizations
import SDGHTML

import SDGPersistenceTestUtilities
import SDGXCTestUtilities

class SDGHTMLAPITests : TestCase {

    func testEscaping() {
        XCTAssertFalse(HTML.escapeTextForCharacterData("<").contains("<"))
        XCTAssertFalse(HTML.escapeTextForAttribute("\u{22}").contains("\u{22}"))
    }

    func testHTMLElement() {
        XCTAssertEqual(
            HTMLElement("html", attributes: ["lang": "en"], contents: "<body></body>", inline: false).source(),
            "<html lang=\u{22}en\u{22}>\n<body></body>\n</html>")
        XCTAssertEqual(
            HTMLElement("span", attributes: ["class": "\u{22}"], contents: "...", inline: true).source(),
            "<span class=\u{22}&#x0022;\u{22}>...</span>")
    }

    func testParsing() throws {

        XCTAssert(try DocumentSyntax.parse(source:
            "<tag attribute=\u{22}value\u{22}></tag>"
            ).get().descendents().contains(where: { $0 is AttributeSyntax }))

        switch try DocumentSyntax.parse(source:
            "<empty attribute>\n<tag>\n</tag>"
            ).get().content.elements.first!.kind {
        case .element(let element):
            XCTAssertEqual(element.openingTag.name.source(), "empty")
        case .text:
            XCTFail()
        }

        var document = try DocumentSyntax.parse(source:
            "<tag attribute=\u{22}value\u{22}>text</tag>"
            ).get()
        let element = document.descendents().first(where: { $0 is ElementSyntax }) as? ElementSyntax
        XCTAssert(element?.openingTag.lessThan.source() == "<")
        XCTAssert(element?.openingTag.greaterThan.source() == ">")
        XCTAssert(element?.openingTag.attributes?.attributes?.first?.whitespace.source() == " ")
        XCTAssert(element?.openingTag.attributes?.attributes?.first?.whitespace.source() == " ")
        XCTAssert(element?.openingTag.attributes?.attributes?.first?.value?.equals.source() == "=")
        XCTAssert(element?.openingTag.attributes?.attributes?.first?.value?.openingQuotationMark.source() == "\u{22}")
        XCTAssert(element?.openingTag.attributes?.attributes?.first?.value?.closingQuotationMark.source() == "\u{22}")
        XCTAssertNil(element?.openingTag.attributes?.trailingWhitespace)
        XCTAssert(element?.continuation?.content.source() == "text")
        XCTAssert(element?.continuation?.closingTag.lessThan.source() == "<")
        XCTAssert(element?.continuation?.closingTag.slash.source() == "/")
        XCTAssert(element?.continuation?.closingTag.name.source() == "tag")
        XCTAssert(element?.continuation?.closingTag.greaterThan.source() == ">")
        let text = element?.descendents().first(where: { $0 is TextSyntax }) as? TextSyntax
        XCTAssertEqual(text?.text.source(), "text")

        document = try DocumentSyntax.parse(source:
            "<a><b>"
            ).get()
        XCTAssertEqual(document.content.elements.dropFirst().count, 1)
        _ = document.content.elements.index(before: document.content.elements.endIndex)

        var string: String = ""
        document.write(to: &string)
        XCTAssertEqual(string, document.source())
    }

    func testPercentEncoding() {
        XCTAssertEqual(HTML.percentEncodeURLPath("Ελληνικό κείμενο"), "Ελληνικό%20κείμενο")
    }

    func testRedirect() {
        compare(String(Redirect(target: "../").contents), against: testSpecificationDirectory().appendingPathComponent("Redirect.txt"), overwriteSpecificationInsteadOfFailing: false)
    }

    func testSyntaxError() {
        func expectViolation(named name: String, in string: String, overwriteSpecificationInsteadOfFailing: Bool, file: StaticString = #file, line: UInt = #line) {
            var errors: [SyntaxError] = []
            switch DocumentSyntax.parse(source: string) {
            case .failure(let error):
                errors.append(error)
            case .success(let document):
                let validated = document.validate(baseURL: URL(fileURLWithPath: "/"))
                XCTAssert(¬validated.isEmpty, "No error detected.", file: file, line: line)
                errors.append(contentsOf: validated)
            }
            var report: [StrictString] = []
            for localization in InterfaceLocalization.allCases {
                report.append(localization.icon ?? StrictString(localization.code))
                LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                    for error in errors {
                        report.append("")
                        report.append(error.presentableDescription())
                    }
                }
            }
            compare(
                String(report.joined(separator: "\n")),
                against: testSpecificationDirectory().appendingPathComponent("SyntaxError/\(name).txt"),
                overwriteSpecificationInsteadOfFailing: overwriteSpecificationInsteadOfFailing,
                file: file,
                line: line)
        }

        expectViolation(
            named: "Dead Remote Link",
            in: "<a href=\u{22}http://doesnotexist.invalid\u{22}></a>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Missing Attribute Value",
            in: "<a href></a>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Invalid Attribute Value",
            in: "<a hidden=\u{22}value\u{22}></a>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Dead Relative Link",
            in: "<a href=\u{22}does/not/exist\u{22}></a>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Invalid URL",
            in: "<a href=\u{22}\u{22}></a>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Unpaired Quotation Mark",
            in: "<tag attribute=\u{22}>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Nameless Tag",
            in: "<>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Unpaired Tag Delimiters",
            in: "tag attribute=\u{22}value\u{22}>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Unknown Attribute",
            in: "<tag doesnotexist>",
            overwriteSpecificationInsteadOfFailing: false)
    }

    func testTextDirection() {
        enum TestLocalization : String, Localization {
            case עברית = "he"
            case ελληνικά = "el"
            case undefined = "und"
            static var fallbackLocalization: TestLocalization = .עברית
        }
        XCTAssertEqual(TestLocalization.עברית.textDirection.htmlAttribute, "rtl")
        XCTAssertEqual(TestLocalization.ελληνικά.textDirection.htmlAttribute, "ltr")
        XCTAssertEqual(TestLocalization.undefined.textDirection.htmlAttribute, "auto")
    }

    func testValidLink() throws {
        let document = try DocumentSyntax.parse(source:
            "<a href=\u{22}http://www.google.com\u{22}></a>"
            ).get()
        XCTAssert(document.validate(baseURL: URL(string: "/")!).isEmpty)
    }
}
