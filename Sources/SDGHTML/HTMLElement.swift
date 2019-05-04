/*
 HTMLElement.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// An HTML element.
public struct HTMLElement {

    // MARK: - Initialization

    /// Creates an HTMLElement.
    ///
    /// - Properties:
    ///     - element: The element name. (e.g. “html”, “head”, "body")
    ///     - attributes: The HTML attributes.
    ///     - contents: The contents of the element.
    ///     - inline: Whether or not to treat the element as inline for the purposes of source formatting.
    public init(
        _ element: StrictString,
        attributes: [StrictString: StrictString] = [:],
        contents: StrictString,
        inline: Bool) {
        self.element = element
        self.inline = inline
        self.attributes = attributes
        self.contents = contents
    }

    // MARK: - Properties

    /// The element name.
    public var element: StrictString
    /// Whether or not to treat the element as inline for the purposes of source formatting.
    public var inline: Bool
    /// The HTML attributes.
    public var attributes: [StrictString: StrictString]
    /// The contents of the element.
    public var contents: StrictString

    // MARK: - Source

    /// Returns the element’s HTML source.
    public func source() -> StrictString {

        var result: StrictString = "<"
        result.append(contentsOf: element)
        for attribute in attributes.keys.sorted() {
            result.append(" ")
            result.append(contentsOf: attribute)
            result.append(contentsOf: "=\u{22}".scalars)
            result.append(contentsOf: HTML.escapeTextForAttribute(attributes[attribute]!))
            result.append("\u{22}")
        }
        result.append(">")

        if ¬inline {
            result.append("\n")
        }
        result.append(contentsOf: contents)
        if ¬inline {
            result.append("\n")
        }

        result.append(contentsOf: "</".scalars)
        result.append(contentsOf: element)
        result.append(">")

        return result
    }
}
