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

class APITests: TestCase {

  func testAttribute() {
    var attribute = AttributeSyntax(name: TokenSyntax(kind: .attributeName("attribute")))
    XCTAssertEqual(attribute.source(), " attribute")
    attribute.whitespace = TokenSyntax(kind: .whitespace("  "))
    attribute.name = TokenSyntax(kind: .attributeName("name"))
    attribute.value = AttributeValueSyntax(value: TokenSyntax(kind: .attributeText("value")))
    XCTAssertEqual(attribute.source(), "  name=\u{22}value\u{22}")

    attribute = AttributeSyntax(name: "title")  // Better empty
    XCTAssertEqual(attribute.source(), " title=\u{22}\u{22}")
    attribute = AttributeSyntax(name: "hidden")  // Better none
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
    element.set(attribute: "attribute", to: "value")
    XCTAssertEqual(element.valueOfAttribute(named: "attribute"), "value")
    element.identifier = "identifier"
    XCTAssertEqual(element.identifier, "identifier")
    element.classes = ["class"]
    XCTAssertEqual(element.classes, ["class"])
    element.language = "he"
    XCTAssertEqual(element.language, "he")
    element.textDirection = "rtl"
    XCTAssertEqual(element.textDirection, "rtl")
    element.translationIntent = false
    XCTAssertEqual(element.translationIntent, false)
    element.translationIntent = true
    XCTAssertEqual(element.translationIntent, true)
    element.translationIntent = nil
    XCTAssertEqual(element.translationIntent, nil)
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
    attributes = AttributesSyntax(
      attributes: nil,
      trailingWhitespace: TokenSyntax(kind: .whitespace(" "))
    )
    XCTAssertEqual(attributes.attributeDictionary, [:])

    attributes = AttributesSyntax(dictionary: ["name": "value"])!
    XCTAssertEqual(attributes.attribute(named: "name")?.source(), " name=\u{22}value\u{22}")
    attributes = AttributesSyntax(
      attributes: nil,
      trailingWhitespace: TokenSyntax(kind: .whitespace(" "))
    )
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

    let withEntities = AttributeValueSyntax(
      value: TokenSyntax(kind: .attributeText("&#2010;&8208;&hyphen;&not‐an‐entity;"))
    )
    XCTAssertEqual(withEntities.valueText, "‐‐‐&not‐an‐entity;")
  }

  func testComment() {
    var comment = CommentSyntax(
      openingToken: TokenSyntax(kind: .commentStart),
      contents: TokenSyntax(kind: .commentText("...")),
      closingToken: TokenSyntax(kind: .commentEnd)
    )
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
    tag.nameText = "changed"
    XCTAssertEqual(tag.nameText, "changed")
  }

  func testDocument() {
    var document = DocumentSyntax(content: ListSyntax<ContentSyntax>(entries: []))
    XCTAssertEqual(document.source(), "")
    document.content.append(
      ContentSyntax(kind: .text(TextSyntax(text: TokenSyntax(kind: .text("Text.")))))
    )
    XCTAssertEqual(document.source(), "Text.")
  }

  func testElement() {
    var element = ElementSyntax(
      openingTag: OpeningTagSyntax(name: TokenSyntax(kind: .elementName("element")))
    )
    XCTAssertEqual(element.source(), "<element>")
    element.openingTag.name = TokenSyntax(kind: .elementName("name"))
    element.continuation = ElementContinuationSyntax(
      content: ListSyntax(),
      closingTag: ClosingTagSyntax(name: TokenSyntax(kind: .elementName("name")))
    )
    XCTAssertEqual(element.source(), "<name></name>")

    element = ElementSyntax(name: "name", empty: false)
    XCTAssertEqual(element.source(), "<name></name>")
    element = ElementSyntax(name: "name", empty: true)
    XCTAssertEqual(element.source(), "<name>")

    element = ElementSyntax(
      name: "name",
      attributes: ["attribute": "value", "eigenschaft": "wert"],
      empty: true
    )
    XCTAssertEqual(
      element.source(),
      "<name attribute=\u{22}value\u{22} eigenschaft=\u{22}wert\u{22}>"
    )
    let newAttributes = ["attribute": "new value", "eigenschaft": "neuer wert"]
    element.attributeDictionary = newAttributes
    XCTAssertEqual(
      element.source(),
      "<name attribute=\u{22}new value\u{22} eigenschaft=\u{22}neuer wert\u{22}>"
    )
    XCTAssertEqual(element.attributeDictionary, newAttributes)

    element = ElementSyntax(name: "original", empty: false)
    element.nameText = "changed"
    XCTAssertEqual(element.nameText, "changed")
    XCTAssertEqual(element.source(), "<changed></changed>")
    element.attributeDictionary = ["name": "value"]
    XCTAssertEqual(element.attribute(named: "name")?.value?.valueText, "value")

    element = ElementSyntax(name: "name", empty: true)
    element.content.append(
      ContentSyntax(kind: .text(TextSyntax(text: TokenSyntax(kind: .text("content")))))
    )
    XCTAssertEqual(element.source(), "<name>content</name>")
    element.content = []
    XCTAssertEqual(element.source(), "<name></name>")
    element = ElementSyntax(name: "name", empty: true)
    element.content = []
    XCTAssertEqual(element.source(), "<name>")
  }

  func testElementContinuation() {
    var continuation = ElementContinuationSyntax(
      content: ListSyntax<ContentSyntax>(entries: []),
      closingTag: ClosingTagSyntax(name: TokenSyntax(kind: .elementName("tag")))
    )
    XCTAssertEqual(continuation.source(), "</tag>")
    continuation.content.append(
      ContentSyntax(kind: .text(TextSyntax(text: TokenSyntax(kind: .text("Text.")))))
    )
    continuation.closingTag.name = TokenSyntax(kind: .elementName("name"))
    XCTAssertEqual(continuation.source(), "Text.</name>")
  }

  func testElementFactories() {
    func compare(
      _ element: ElementSyntax,
      to specification: String,
      overwriteSpecificationInsteadOfFailing: Bool,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      let formatted = element.formatted()
      let source = formatted.source()
      SDGPersistenceTestUtilities.compare(
        source,
        against: testSpecificationDirectory()
          .appendingPathComponent("ElementSyntax").appendingPathComponent(specification + ".txt"),
        overwriteSpecificationInsteadOfFailing: overwriteSpecificationInsteadOfFailing,
        file: file,
        line: line
      )
    }
    compare(.article(), to: "Article", overwriteSpecificationInsteadOfFailing: false)
    compare(
      .author("John Doe", language: InterfaceLocalization.englishCanada),
      to: "Author",
      overwriteSpecificationInsteadOfFailing: false
    )
    compare(.body(), to: "Body", overwriteSpecificationInsteadOfFailing: false)
    compare(
      .css(url: URL(fileURLWithPath: "Some Relative Path/Chemin d’accès/CSS.css")),
      to: "CSS",
      overwriteSpecificationInsteadOfFailing: false
    )
    compare(
      .description("A document."),
      to: "Description",
      overwriteSpecificationInsteadOfFailing: false
    )
    compare(.division(), to: "Division", overwriteSpecificationInsteadOfFailing: false)
    compare(.encoding(), to: "Encoding", overwriteSpecificationInsteadOfFailing: false)
    compare(.header(), to: "Header", overwriteSpecificationInsteadOfFailing: false)
    compare(
      .metadataTitle("Title < Symbols"),
      to: "Metadata Title",
      overwriteSpecificationInsteadOfFailing: false
    )
    compare(
      .document(
        language: InterfaceLocalization.englishCanada,
        header: .metadataHeader(
          title: .metadataTitle("Title"),
          canonicalURL: .canonical(url: URL(string: "http://example.com/Canonical.html")!),
          author: .author("John Doe", language: InterfaceLocalization.englishCanada),
          description: .description("A description."),
          keywords: .keywords(["keyword", "Schlüsselwort"])
        ),
        body: .body()
      ),
      to: "Document",
      overwriteSpecificationInsteadOfFailing: false
    )
    compare(.lineBreak(), to: "Line Break", overwriteSpecificationInsteadOfFailing: false)
    compare(
      .link(
        target: URL(fileURLWithPath: "Some Relative Path/Chemin d’accès.html"),
        language: InterfaceLocalization.englishUnitedKingdom
      ),
      to: "Link",
      overwriteSpecificationInsteadOfFailing: false
    )
    compare(.navigation(), to: "Navigation", overwriteSpecificationInsteadOfFailing: false)
    compare(.paragraph(), to: "Paragraph", overwriteSpecificationInsteadOfFailing: false)
    compare(
      .portableDocument(url: URL(fileURLWithPath: "Some Relative Path/Chemin d’accès.pdf")),
      to: "Portable Document",
      overwriteSpecificationInsteadOfFailing: false
    )
    compare(.section(), to: "Section", overwriteSpecificationInsteadOfFailing: false)
    compare(.title(), to: "Title", overwriteSpecificationInsteadOfFailing: false)
    compare(
      .languageSwitch(
        targetURL: UserFacing<URL, TestLocalization>({ localization in
          switch localization.interfaceLocalization {
          case .englishUnitedKingdom:
            return URL(string: "https://somewhere.uk")!
          case .englishUnitedStates:
            return URL(string: "https://somewhere.us")!
          case .englishCanada:
            return URL(string: "https://somewhere.ca")!
          case .deutschDeutschland:
            return URL(string: "https://irgendwo.de")!
          case .none:
            return URL(string: "https://somewhere.un")!
          }
        })
      ),
      to: "Language Switch",
      overwriteSpecificationInsteadOfFailing: false
    )
  }

  func testExampleURL() throws {
    let document = try DocumentSyntax.parse(
      source:
        "<a href=\u{22}http://example.com\u{22}></a>"
    ).get()
    XCTAssert(document.validate(baseURL: URL(string: "/")!).isEmpty)
  }

  func testEscaping() {
    XCTAssertFalse(HTML.escapeTextForCharacterData("<").contains("<"))
    XCTAssertFalse(HTML.escapeTextForAttribute("\u{22}").contains("\u{22}"))
  }

  func testFormatting() throws {
    var documentSource =
      "<!DOCTYPE  html > <html lang=\u{22}zxx\u{22} > <head> <title> ... </title> </head> <body> </body> </html>"
    var document = try DocumentSyntax.parse(source: documentSource).get()
    XCTAssertEqual(document.source(), documentSource)
    XCTAssertEqual(
      document.formatted().source(),
      [
        "<!DOCTYPE html>",
        "<html lang=\u{22}zxx\u{22}>",
        " <head>",
        "  <title>...</title>",
        " </head>",
        " <body></body>",
        "</html>"
      ].joined(separator: "\n")
    )
    document.format()

    documentSource = "<!DOCTYPE html><!\u{2D}\u{2D}Comment\u{2D}\u{2D}><html></html>"
    document = try DocumentSyntax.parse(source: documentSource).get()
    XCTAssertEqual(document.source(), documentSource)
    XCTAssertEqual(
      document.formatted().source(),
      [
        "<!DOCTYPE html>",
        "<!\u{2D}\u{2D} Comment \u{2D}\u{2D}>",
        "<html></html>"
      ].joined(separator: "\n")
    )

    documentSource = "<!DOCTYPE html>"
    document = try DocumentSyntax.parse(source: documentSource).get()
    XCTAssertEqual(document.source(), documentSource)
    XCTAssertEqual(
      document.formatted().source(),
      [
        "<!DOCTYPE html>"
      ].joined(separator: "\n")
    )

    documentSource = "<link rel=\u{22}...\u{22} href=\u{22}...\u{22}>"
    document = try DocumentSyntax.parse(source: documentSource).get()
    XCTAssertEqual(document.source(), documentSource)
    XCTAssertEqual(
      document.formatted().source(),
      [
        "<link href=\u{22}...\u{22} rel=\u{22}...\u{22}>"
      ].joined(separator: "\n")
    )

    documentSource =
      "<img alt=\u{22}... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ...\u{22} id=\u{22}... ... ...\u{22} src=\u{22}... ... ... ... ... ... ... ... ... ...\u{22}>"
    document = try DocumentSyntax.parse(source: documentSource).get()
    XCTAssertEqual(document.source(), documentSource)
    XCTAssertEqual(
      document.formatted().source(),
      [
        "<img",
        " alt=\u{22}... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ... ...\u{22}",
        " id=\u{22}... ... ...\u{22}",
        " src=\u{22}... ... ... ... ... ... ... ... ... ...\u{22}",
        ">"
      ].joined(separator: "\n")
    )

    documentSource = "<div>Label: <a>Field</a></div>"
    document = try DocumentSyntax.parse(source: documentSource).get()
    XCTAssertEqual(document.source(), documentSource)
    XCTAssertEqual(
      document.formatted().source(),
      [
        "<div>",
        " Label:",
        " <a>Field</a>",
        "</div>"
      ].joined(separator: "\n")
    )

    documentSource = "<h4>Excessive whitespace     in the middle.</h4>"
    document = try DocumentSyntax.parse(source: documentSource).get()
    XCTAssertEqual(document.source(), documentSource)
    XCTAssertEqual(
      document.formatted().source(),
      [
        "<h4>Excessive whitespace in the middle.</h4>"
      ].joined(separator: "\n")
    )

    documentSource = "<p ></p>"
    document = try DocumentSyntax.parse(source: documentSource).get()
    XCTAssertEqual(document.source(), documentSource)
    XCTAssertEqual(
      document.formatted().source(),
      [
        "<p></p>"
      ].joined(separator: "\n")
    )
  }

  func testListSyntax() {
    XCTAssertEqual(ListSyntax<ContentSyntax>().source(), "")
    var attributeList: ListSyntax<AttributeSyntax> = []
    XCTAssertEqual(attributeList.attributeDictionary, [:])
    attributeList.append(AttributeSyntax(name: "hidden"))
    XCTAssertEqual(attributeList.source(), " hidden")
    XCTAssertEqual(attributeList.attributeDictionary, ["hidden": ""])
    attributeList.attributeDictionary = ["attribute": "value"]
    XCTAssertEqual(attributeList.attributeDictionary, ["attribute": "value"])
    attributeList.attributeDictionary = [:]
    attributeList.apply(attribute: AttributeSyntax(name: "attribute"))
    attributeList.apply(attribute: AttributeSyntax(name: "attribute"))
    XCTAssertEqual(attributeList.attributeDictionary.count, 1)
  }

  func testOpeningTag() {
    var tag = OpeningTagSyntax(name: TokenSyntax(kind: .elementName("tag")))
    XCTAssertEqual(tag.source(), "<tag>")
    tag.lessThan = TokenSyntax(kind: .lessThan)
    tag.name = TokenSyntax(kind: .elementName("name"))
    tag.attributes = AttributesSyntax(
      attributes: nil,
      trailingWhitespace: TokenSyntax(kind: .whitespace(" "))
    )
    tag.greaterThan = TokenSyntax(kind: .greaterThan)
    XCTAssertEqual(tag.source(), "<name >")

    tag = OpeningTagSyntax(name: "name")
    XCTAssertEqual(tag.attributeDictionary, [:])
  }

  func testParsing() throws {

    XCTAssert(
      try DocumentSyntax.parse(
        source:
          "<tag attribute=\u{22}value\u{22}></tag>"
      ).get().descendents().contains(where: { $0 is AttributeSyntax })
    )

    switch try DocumentSyntax.parse(
      source:
        "<empty attribute>\n<tag>\n</tag>"
    ).get().content.first!.kind {
    case .element(let element):
      XCTAssertEqual(element.openingTag.name.source(), "empty")
    case .text, .comment:
      XCTFail()
    }

    var document = try DocumentSyntax.parse(
      source:
        "<tag attribute=\u{22}value\u{22}>text</tag>"
    ).get()
    let element = document.descendents().first(where: { $0 is ElementSyntax }) as? ElementSyntax
    XCTAssert(element?.openingTag.lessThan.source() == "<")
    XCTAssert(element?.openingTag.greaterThan.source() == ">")
    XCTAssert(element?.openingTag.attributes?.attributes?.first?.whitespace.source() == " ")
    XCTAssert(element?.openingTag.attributes?.attributes?.first?.whitespace.source() == " ")
    XCTAssert(element?.openingTag.attributes?.attributes?.first?.value?.equals.source() == "=")
    XCTAssert(
      element?.openingTag.attributes?.attributes?.first?.value?.openingQuotationMark.source()
        == "\u{22}"
    )
    XCTAssert(
      element?.openingTag.attributes?.attributes?.first?.value?.closingQuotationMark.source()
        == "\u{22}"
    )
    XCTAssertNil(element?.openingTag.attributes?.trailingWhitespace)
    XCTAssert(element?.continuation?.content.source() == "text")
    XCTAssert(element?.continuation?.closingTag.lessThan.source() == "<")
    XCTAssert(element?.continuation?.closingTag.slash.source() == "/")
    XCTAssert(element?.continuation?.closingTag.name.source() == "tag")
    XCTAssert(element?.continuation?.closingTag.greaterThan.source() == ">")
    let text = element?.descendents().first(where: { $0 is TextSyntax }) as? TextSyntax
    XCTAssertEqual(text?.text.source(), "text")

    document = try DocumentSyntax.parse(
      source:
        "<a><b>"
    ).get()
    XCTAssertEqual(document.content.dropFirst().count, 1)
    _ = document.content.index(before: document.content.endIndex)

    var string: String = ""
    document.write(to: &string)
    XCTAssertEqual(string, document.source())
    XCTAssertEqual(document.wrappedInstance as? String, document.source())

    XCTAssert(
      try DocumentSyntax.parse(
        source:
          "<!\u{2D}\u{2D} Comment \u{2D}\u{2D}>"
      ).get().descendents().contains(where: { $0 is CommentSyntax })
    )
  }

  func testPercentEncoding() throws {
    XCTAssertEqual(HTML.percentEncodeURLPath("Ελληνικό κείμενο"), "Ελληνικό%20κείμενο")

    let url = "../Mock Projects"
    let thisFile = URL(fileURLWithPath: #file)
    func validate(url: String) throws -> [SyntaxError] {
      let document = try DocumentSyntax.parse(
        source: "<a href=\u{22}\(url)\u{22}>Space is not encoded.</a>"
      ).get()
      return document.validate(baseURL: thisFile)
    }
    XCTAssert(try ¬validate(url: url).isEmpty, "Failed to warn about unencoded space.")
    XCTAssert(
      try validate(url: HTML.percentEncodeURLPath(url)).isEmpty,
      "Unrelated warning occurred."
    )
  }

  func testRedirect() {
    compare(
      String(
        DocumentSyntax.redirect(
          language: InterfaceLocalization.englishCanada,
          target: URL(fileURLWithPath: "../")
        ).source()
      ),
      against: testSpecificationDirectory().appendingPathComponent("Redirect.txt"),
      overwriteSpecificationInsteadOfFailing: false
    )
    enum RightToLeftLocalization: String, Localization {
      case עברית = "he"
      static let fallbackLocalization: RightToLeftLocalization = .עברית
    }
    compare(
      String(
        DocumentSyntax.redirect(
          language: RightToLeftLocalization.עברית,
          target: URL(fileURLWithPath: "../")
        ).source()
      ),
      against: testSpecificationDirectory().appendingPathComponent("Redirect (Right‐to‐Left).txt"),
      overwriteSpecificationInsteadOfFailing: false
    )
  }

  func testSyntaxError() {
    func expectViolation(
      named name: String,
      in string: String,
      overwriteSpecificationInsteadOfFailing: Bool,
      file: StaticString = #file,
      line: UInt = #line
    ) {
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
        line: line
      )
    }

    expectViolation(
      named: "Dead Remote Link",
      in: "<a href=\u{22}http://doesnotexist.invalid\u{22}></a>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Missing Attribute Value",
      in: "<a href></a>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Invalid Attribute Value",
      in: "<a hidden=\u{22}value\u{22}></a>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Dead Relative Link",
      in: "<a href=\u{22}does/not/exist\u{22}></a>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Invalid URL",
      in: "<a href=\u{22}\u{22}></a>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Unpaired Quotation Mark",
      in: "<tag attribute=\u{22}>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Nameless Tag",
      in: "<>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Unpaired Tag Delimiters",
      in: "tag attribute=\u{22}value\u{22}>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Unknown Attribute",
      in: "<tag doesnotexist>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Nameless Tag with Attributes",
      in: "<attribute=\u{22}value\u{22}>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Extraneous Closing Tag",
      in: "Content</tag>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Nameless Tag with Multiple Attributes",
      in: "<attribute=\u{22}value\u{22} attribute=\u{22}value\u{22}>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Unpaired Comment Markers",
      in: "Comment \u{2D}\u{2D}>",
      overwriteSpecificationInsteadOfFailing: false
    )
    expectViolation(
      named: "Skipped Heading",
      in: "<html><h1>...</h1><h3>...</h3></html>",
      overwriteSpecificationInsteadOfFailing: false
    )
  }

  func testSyntaxUnfolder() {
    func testUnfolding(
      of start: String,
      to end: String,
      file: StaticString = #file,
      line: UInt = #line
    ) {
      do {
        var syntax = try DocumentSyntax.parse(source: start).get()
        syntax.unfold()
        let source = syntax.source()
        XCTAssertEqual(source, end, file: file, line: line)
      } catch {
        XCTFail(error.localizedDescription)
      }
    }
    testUnfolding(
      of: "...<foreign>...</foreign>...",
      to: "...<span class=\u{22}foreign\u{22}>...</span>..."
    )
  }

  func testTextDirection() {
    enum TestLocalization: String, Localization {
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
    let document = try DocumentSyntax.parse(
      source:
        "<a href=\u{22}http://www.google.com\u{22}></a>"
    ).get()
    XCTAssert(document.validate(baseURL: URL(string: "/")!).isEmpty)
  }
}
