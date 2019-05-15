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

        XCTAssert((try DocumentSyntax.parse(source:
            "<tag attribute=\u{22}value\u{22}></tag>"
            ).get().descendents().first(where: { $0 is AttributeSyntax }) as? AttributeSyntax)?.whitespace.source() == " ")
    }

    func testPercentEncoding() {
        XCTAssertEqual(HTML.percentEncodeURLPath("Ελληνικό κείμενο"), "Ελληνικό%20κείμενο")
    }

    func testRedirect() {
        compare(String(Redirect(target: "../").contents), against: testSpecificationDirectory().appendingPathComponent("Redirect.txt"), overwriteSpecificationInsteadOfFailing: false)
    }

    func testSyntaxError() {
        func expectViolation(named name: String, in string: String, file: StaticString = #file, line: UInt = #line) {
            var errors: [SyntaxError] = []
            switch DocumentSyntax.parse(source: string) {
            case .failure(let error):
                errors.append(error)
            case .success(let document):
                errors.append(contentsOf: document.validate(baseURL: URL(fileURLWithPath: "/")))
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
                overwriteSpecificationInsteadOfFailing: false)
        }

        expectViolation(named: "Dead Remote Link", in: "<a href=\u{22}http://doesnotexist.invalid\u{22}></a>")
        expectViolation(named: "Missing Attribute Value", in: "<a href></a>")
        expectViolation(named: "Invalid Attribute Value", in: "<a hidden=\u{22}value\u{22}></a>")
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
}
