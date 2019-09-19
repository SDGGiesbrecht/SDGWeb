/*
 APITests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGText
import SDGLocalization

import SDGWebLocalizations
import SDGHTML

import XCTest

import SDGPersistenceTestUtilities
import SDGXCTestUtilities

class APITests : TestCase {

    func testAttribute() {
        var attribute = AttributeSyntax(name: TokenSyntax(kind: .attributeName("attribute")))
        XCTAssertEqual(attribute.source(), " attribute")
        attribute.whitespace = TokenSyntax(kind: .whitespace("  "))
        attribute.name = TokenSyntax(kind: .attributeName("name"))
        attribute.value = AttributeValueSyntax(value: TokenSyntax(kind: .attributeText("value")))
        XCTAssertEqual(attribute.source(), "  name=\u{22}value\u{22}")

        attribute = AttributeSyntax(name: "title") // Better empty
        XCTAssertEqual(attribute.source(), " title=\u{22}\u{22}")
        attribute = AttributeSyntax(name: "hidden") // Better none
        XCTAssertEqual(attribute.source(), " hidden")

        attribute = AttributeSyntax(name: "name", value: "value")
        attribute.nameText = "renamed"
        XCTAssertEqual(attribute.nameText, "renamed")
        attribute.valueText = "changed"
        XCTAssertEqual(attribute.valueText, "changed")
    }

    func testAttributed() {
        var element = ElementSyntax(name: "name", empty: true)
        element.set(attribute: "attribute", to: "value")
        XCTAssertEqual(element.source(), "<name attribute=\u{22}value\u{22}>")
        element.set(attribute: "attribute", to: nil)
        XCTAssertEqual(element.source(), "<name>")
    }

    func testAttributes() {
        var attributes = AttributesSyntax(attributes: nil)
        XCTAssertEqual(attributes.source(), "")
        attributes.attributes = ListSyntax<AttributeSyntax>(entries: [
            AttributeSyntax(name: TokenSyntax(kind: .attributeName("one"))),
            AttributeSyntax(name: TokenSyntax(kind: .attributeName("two"))),
            ])
        attributes.trailingWhitespace = TokenSyntax(kind: .whitespace(" "))
        XCTAssertEqual(attributes.source(), " one two ")
        attributes = AttributesSyntax()
        XCTAssertEqual(attributes.source(), "")
        attributes.attributeDictionary = ["name": "value"]
        XCTAssertEqual(attributes.attributeDictionary, ["name": "value"])
        attributes = AttributesSyntax(attributes: nil, trailingWhitespace: TokenSyntax(kind: .whitespace(" ")))
        XCTAssertEqual(attributes.attributeDictionary, [:])

        attributes = AttributesSyntax(dictionary: ["name": "value"])!
        XCTAssertEqual(attributes.attribute(named: "name")?.source(), " name=\u{22}value\u{22}")
        attributes = AttributesSyntax(attributes: nil, trailingWhitespace: TokenSyntax(kind: .whitespace(" ")))
        attributes.apply(attribute: AttributeSyntax(name: "name", value: "value"))
        XCTAssertEqual(attributes.attributeDictionary, ["name": "value"])
    }

    func testAttributeValue() {
        var value = AttributeValueSyntax(value: TokenSyntax(kind: .attributeText("value")))
        XCTAssertEqual(value.source(), "=\u{22}value\u{22}")
        value.equals = TokenSyntax(kind: .equalsSign)
        value.openingQuotationMark = TokenSyntax(kind: .quotationMark)
        value.value = TokenSyntax(kind: .attributeText("new value"))
        value.closingQuotationMark = TokenSyntax(kind: .quotationMark)
        XCTAssertEqual(value.source(), "=\u{22}new value\u{22}")

        _ = AttributeValueSyntax(value: nil)
        value.valueText = "text"
        XCTAssertEqual(value.valueText, "text")
    }

    func testComment() {
        var comment = CommentSyntax(
            openingToken: TokenSyntax(kind: .commentStart),
            contents: TokenSyntax(kind: .commentText("...")),
            closingToken: TokenSyntax(kind: .commentEnd))
        XCTAssertEqual(comment.source(), "<!\u{2D}\u{2D}...\u{2D}\u{2D}>")
        comment.openingToken = TokenSyntax(kind: .commentStart)
        XCTAssertEqual(comment.openingToken.source(), "<!\u{2D}\u{2D}")
        comment.contents = TokenSyntax(kind: .commentText("..."))
        XCTAssertEqual(comment.contents.source(), "...")
        comment.closingToken = TokenSyntax(kind: .commentEnd)
        XCTAssertEqual(comment.closingToken.source(), "\u{2D}\u{2D}>")
        XCTAssertEqual(comment.source(), "<!\u{2D}\u{2D}...\u{2D}\u{2D}>")
    }

    func testClosingTag() {
        var tag = ClosingTagSyntax(name: TokenSyntax(kind: .elementName("tag")))
        XCTAssertEqual(tag.source(), "</tag>")
        tag.lessThan = TokenSyntax(kind: .lessThan)
        tag.slash = TokenSyntax(kind: .slash)
        tag.name = TokenSyntax(kind: .elementName("name"))
        tag.greaterThan = TokenSyntax(kind: .greaterThan)
        XCTAssertEqual(tag.source(), "</name>")
    }

    func testContent() {
        var content = ContentSyntax(elements: ListSyntax<ContentElementSyntax>(entries: []))
        XCTAssertEqual(content.source(), "")
        content.elements.append(ContentElementSyntax(kind: .text(TextSyntax(text: TokenSyntax(kind: .text("Text."))))))
        XCTAssertEqual(content.source(), "Text.")
        content.elements[0] = ContentElementSyntax(kind: .text(TextSyntax(text: TokenSyntax(kind: .text("Modified.")))))
        XCTAssertEqual(content.source(), "Modified.")
    }

    func testDocument() {
        var document = DocumentSyntax(content:
            ContentSyntax(elements: ListSyntax<ContentElementSyntax>(entries: [])))
        XCTAssertEqual(document.source(), "")
        document.content.elements.append(ContentElementSyntax(kind: .text(TextSyntax(text: TokenSyntax(kind: .text("Text."))))))
        XCTAssertEqual(document.source(), "Text.")
    }

    func testElement() {
        var element = ElementSyntax(openingTag: OpeningTagSyntax(name: TokenSyntax(kind: .elementName("element"))))
        XCTAssertEqual(element.source(), "<element>")
        element.openingTag.name = TokenSyntax(kind: .elementName("name"))
        element.continuation = ElementContinuationSyntax(
            content: ContentSyntax(elements: ListSyntax()),
            closingTag: ClosingTagSyntax(name: TokenSyntax(kind: .elementName("name"))))
        XCTAssertEqual(element.source(), "<name></name>")

        element = ElementSyntax(name: "name", empty: false)
        XCTAssertEqual(element.source(), "<name></name>")
        element = ElementSyntax(name: "name", empty: true)
        XCTAssertEqual(element.source(), "<name>")

        element = ElementSyntax(
            name: "name",
            attributes: ["attribute": "value", "eigenschaft": "wert"],
            empty: true)
        XCTAssertEqual(element.source(), "<name attribute=\u{22}value\u{22} eigenschaft=\u{22}wert\u{22}>")
        let newAttributes = ["attribute": "new value", "eigenschaft": "neuer wert"]
        element.attributeDictionary = newAttributes
        XCTAssertEqual(
            element.source(),
            "<name attribute=\u{22}new value\u{22} eigenschaft=\u{22}neuer wert\u{22}>")
        XCTAssertEqual(element.attributeDictionary, newAttributes)

        element = ElementSyntax(name: "original", empty: false)
        element.name = "changed"
        XCTAssertEqual(element.name, "changed")
        XCTAssertEqual(element.source(), "<changed></changed>")
        element.attributeDictionary = ["name": "value"]
        XCTAssertEqual(element.attribute(named: "name")?.value?.valueText, "value")
    }

    func testElementContinuation() {
        var continuation = ElementContinuationSyntax(
            content: ContentSyntax(elements: ListSyntax<ContentElementSyntax>(entries: [])),
            closingTag: ClosingTagSyntax(name: TokenSyntax(kind: .elementName("tag"))))
        XCTAssertEqual(continuation.source(), "</tag>")
        continuation.content.elements.append(ContentElementSyntax(kind: .text(TextSyntax(text: TokenSyntax(kind: .text("Text."))))))
        continuation.closingTag.name = TokenSyntax(kind: .elementName("name"))
        XCTAssertEqual(continuation.source(), "Text.</name>")
    }

    func testExampleURL() throws {
        let document = try DocumentSyntax.parse(source:
            "<a href=\u{22}http://example.com\u{22}></a>"
            ).get()
        XCTAssert(document.validate(baseURL: URL(string: "/")!).isEmpty)
    }

    func testEscaping() {
        XCTAssertFalse(HTML.escapeTextForCharacterData("<").contains("<"))
        XCTAssertFalse(HTML.escapeTextForAttribute("\u{22}").contains("\u{22}"))
    }

    func testListSyntax() {
        XCTAssertEqual(ListSyntax<ContentElementSyntax>().source(), "")
        var attributeList: ListSyntax<AttributeSyntax> = []
        XCTAssertEqual(attributeList.attributeDictionary, [:])
        attributeList.append(AttributeSyntax(name: "hidden"))
        XCTAssertEqual(attributeList.source(), " hidden")
        XCTAssertEqual(attributeList.attributeDictionary, ["hidden": ""])
        attributeList.attributeDictionary = ["attribute": "value"]
        XCTAssertEqual(attributeList.attributeDictionary, ["attribute": "value"])
    }

    func testOpeningTag() {
        var tag = OpeningTagSyntax(name: TokenSyntax(kind: .elementName("tag")))
        XCTAssertEqual(tag.source(), "<tag>")
        tag.lessThan = TokenSyntax(kind: .lessThan)
        tag.name = TokenSyntax(kind: .elementName("name"))
        tag.attributes = AttributesSyntax(attributes: nil, trailingWhitespace: TokenSyntax(kind: .whitespace(" ")))
        tag.greaterThan = TokenSyntax(kind: .greaterThan)
        XCTAssertEqual(tag.source(), "<name >")

        tag = OpeningTagSyntax(name: "name")
        XCTAssertEqual(tag.attributeDictionary, [:])
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
        case .text, .comment:
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
        XCTAssertEqual(document.wrappedInstance as? String, document.source())

        XCTAssert(try DocumentSyntax.parse(source:
            "<!\u{2D}\u{2D} Comment \u{2D}\u{2D}>"
            ).get().descendents().contains(where: { $0 is CommentSyntax }))
    }

    func testPercentEncoding() throws {
        XCTAssertEqual(HTML.percentEncodeURLPath("Ελληνικό κείμενο"), "Ελληνικό%20κείμενο")

        let url = "../Mock Projects"
        let thisFile = URL(fileURLWithPath: #file)
        func validate(url: String) throws -> [SyntaxError] {
            let document = try DocumentSyntax.parse(
                source: "<a href=\u{22}\(url)\u{22}>Space is not encoded.</a>").get()
            return document.validate(baseURL: thisFile)
        }
        XCTAssert(try ¬validate(url: url).isEmpty, "Failed to warn about unencoded space.")
        XCTAssert(try validate(url: HTML.percentEncodeURLPath(url)).isEmpty, "Unrelated warning occurred.")
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
        expectViolation(
            named: "Nameless Tag with Attributes",
            in: "<attribute=\u{22}value\u{22}>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Extraneous Closing Tag",
            in: "Content</tag>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Nameless Tag with Multiple Attributes",
            in: "<attribute=\u{22}value\u{22} attribute=\u{22}value\u{22}>",
            overwriteSpecificationInsteadOfFailing: false)
        expectViolation(
            named: "Unpaired Comment Markers",
            in: "Comment \u{2D}\u{2D}>",
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

    func testText() {
        var text = TextSyntax(text: TokenSyntax(kind: .text("Text.")))
        XCTAssertEqual(text.source(), "Text.")
        text.text = TokenSyntax(kind: .text("Modified."))
        XCTAssertEqual(text.source(), "Modified.")
    }

    func testValidLink() throws {
        let document = try DocumentSyntax.parse(source:
            "<a href=\u{22}http://www.google.com\u{22}></a>"
            ).get()
        XCTAssert(document.validate(baseURL: URL(string: "/")!).isEmpty)
    }
}
