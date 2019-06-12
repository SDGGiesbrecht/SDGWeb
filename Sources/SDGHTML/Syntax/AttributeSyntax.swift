/*
 AttributeSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGCollections
import SDGText
import SDGLocalization

import SDGWebLocalizations

/// An HTML attribute.
public struct AttributeSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case whitespace
        case name
        case value
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal static func parse(fromEndOf source: inout String) -> Result<AttributeSyntax?, SyntaxError> {
        return AttributeValueSyntax.parse(fromEndOf: &source).map { value in
            guard let name = TokenSyntax.parseIdentifer(
                fromEndOf: &source,
                createToken: { .attributeName($0) }) else {
                return nil
            }
            return AttributeSyntax(
                whitespace: TokenSyntax.parseWhitespace(fromEndOf: &source),
                name: name,
                value: value)
        }
    }

    // MARK: - Initialization

    /// Used only by transient instances during parsing.
    private init(whitespace: TokenSyntax?, name: TokenSyntax, value: AttributeValueSyntax?) {
        _storage = SyntaxStorage(children: [whitespace, name, value])
    }

    /// Creates an attribute.
    ///
    /// - Parameters:
    ///     - whitespace: Leading whitespace. (Supplied automatically if omitted.)
    ///     - name: The attribute name.
    ///     - value: Optional. Any attribute value.
    public init(
        whitespace: TokenSyntax = TokenSyntax(kind: .whitespace(" ")),
        name: TokenSyntax,
        value: AttributeValueSyntax? = nil) {
        _storage = SyntaxStorage(children: [whitespace, name, value])
    }

    // MARK: - Children

    /// The leading whitespace.
    public var whitespace: TokenSyntax {
        get {
            return _storage.children[AttributeSyntax.indices[.whitespace]!] as! TokenSyntax
        }
        set {
            _storage.children[AttributeSyntax.indices[.whitespace]!] = newValue
        }
    }

    /// The attribute name.
    public var name: TokenSyntax {
        get {
            return _storage.children[AttributeSyntax.indices[.name]!] as! TokenSyntax
        }
        set {
            _storage.children[AttributeSyntax.indices[.name]!] = newValue
        }
    }

    /// The attribute value.
    public var value: AttributeValueSyntax? {
        get {
            return _storage.children[AttributeSyntax.indices[.value]!] as? AttributeValueSyntax
        }
        set {
            _storage.children[AttributeSyntax.indices[.value]!] = newValue
        }
    }

    // MARK: - Validation

    internal func validate(
        location: String.ScalarView.Index,
        file: String,
        baseURL: URL) -> [SyntaxError] {
        var results: [SyntaxError] = []
        validateValuePresence(location: location, file: file, results: &results)
        return results
    }

    private static let nonEmptyAttributes: Set<String> = [
        "accept",
        "accept\u{2D}charset",
        "accesskey",
        "action",
        "alt",
        "autocomplete",
        "charset",
        "cite",
        "class",
        "colspan",
        "content",
        "contenteditable",
        "coords",
        "data",
        "datetime",
        "dir",
        "dirname",
        "download",
        "draggable",
        "dropzone",
        "enctype",
        "for",
        "form",
        "formaction",
        "headers",
        "high",
        "href",
        "hreflang",
        "http\u{2D}equiv",
        "id",
        "kind",
        "label",
        "lang",
        "list",
        "low",
        "max",
        "maxlength",
        "media",
        "method",
        "min",
        "name",
        "onabort",
        "onafterprint",
        "onbeforeprint",
        "onbeforeunload",
        "onblur",
        "oncanplay",
        "oncanplaythrough",
        "onchange",
        "onclick",
        "oncontextmenu",
        "oncopy",
        "oncuechange",
        "oncut",
        "ondblclick",
        "ondrag",
        "ondragend",
        "ondragenter",
        "ondragleave",
        "ondragover",
        "ondragstart",
        "ondrop",
        "ondurationchange",
        "onemptied",
        "onended",
        "onerror",
        "onfocus",
        "onhashchange",
        "oninput",
        "oninvalid",
        "onkeydown",
        "onkeypress",
        "onkeyup",
        "onload",
        "onloadeddata",
        "onloadedmetadata",
        "onloadstart",
        "onmousedown",
        "onmousemove",
        "onmouseout",
        "onmouseover",
        "onmouseup",
        "onmousewheel",
        "onoffline",
        "onpagehide",
        "onpageshow",
        "onpaste",
        "onpause",
        "onplay",
        "onplaying",
        "onpopstate",
        "onprogress",
        "onratechange",
        "onreset",
        "onresize",
        "onscroll",
        "onsearch",
        "onseeked",
        "onseeking",
        "onselect",
        "onstalled",
        "onstorage",
        "onsubmit",
        "onsuspend",
        "ontimeupdate",
        "ontoggle",
        "onunload",
        "onvolumechange",
        "onwaiting",
        "onwheel",
        "optimum",
        "pattern",
        "placeholder",
        "poster",
        "preload",
        "rel",
        "rowspan",
        "scope",
        "shape",
        "size",
        "span",
        "src",
        "srcdoc",
        "srclang",
        "srcset",
        "start",
        "step",
        "style",
        "tabindex",
        "target",
        "title",
        "translate",
        "type",
        "usemap",
        "value",
    ]
    private static let emptyAttributes: Set<String> = [
        "async",
        "autofocus",
        "autoplay",
        "checked",
        "controls",
        "default",
        "defer",
        "disabled",
        "hidden",
        "ismap",
        "loop",
        "html", // DOCTYPE
        "multiple",
        "muted",
        "novalidate",
        "open",
        "readonly",
        "required",
        "reversed",
        "sandbox",
        "selected",
        "spellcheck",
    ]
    private func validateValuePresence(
        location: String.ScalarView.Index,
        file: String,
        results: inout [SyntaxError]) {
        let name = self.name.source()
        if name ∈ AttributeSyntax.nonEmptyAttributes {
            if value == nil {
                results.append(SyntaxError(
                    file: file,
                    index: location,
                    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "An attribute value is missing."
                        }

                    }),
                    context: self.name.source()))
            }
        } else if name ∈ AttributeSyntax.emptyAttributes {
            if let value = self.value {
                results.append(SyntaxError(
                    file: file,
                    index: location,
                    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "An attribute has an invalid value."
                        }

                    }),
                    context: self.name.source() + value.source()))
            }
        } else {
            results.append(SyntaxError(
                file: file,
                index: location,
                description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Unknown attribute."
                    }

                }),
                context: self.name.source() + (value?.source() ?? "")))
        }
    }

    private static let urlAttributes: Set<String> = ["data", "href", "poster", "src", "srcset"]
    internal func validateURLValue(
        location: String.ScalarView.Index,
        file: String,
        baseURL: URL,
        results: inout [SyntaxError]) {
        if name.source() ∈ AttributeSyntax.urlAttributes,
            let value = self.value {
            let urlString = value.value.source()
            let legacySpecification = urlString.addingPercentEncoding(
                withAllowedCharacters: CharacterSet(charactersIn: Unicode.Scalar(0) ..< Unicode.Scalar(0x80)))!
            if let url = URL(string: legacySpecification, relativeTo: baseURL) {
                var dead = true
                if url.isFileURL {
                    if (try? url.checkResourceIsReachable()) == true {
                        dead = false
                    }
                } else {
                    let request = URLRequest(
                        url: url,
                        cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                        timeoutInterval: 10)
                    let semaphore = DispatchSemaphore(value: 0)
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if error == nil,
                            let status = (response as? HTTPURLResponse)?.statusCode,
                            status.dividedAccordingToEuclid(by: 100) == 2 {
                            dead = false
                        }
                        semaphore.signal()
                    }
                    task.resume()
                    semaphore.wait()
                }
                if dead {
                    results.append(SyntaxError(
                        file: file,
                        index: location,
                        description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                            switch localization {
                            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                                return "A link is dead: \(url.absoluteString)"
                            }
                        }),
                        context: name.source() + value.source()))
                }
            } else {
                results.append(SyntaxError(
                    file: file,
                    index: location,
                    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "A URL is invalid: \(urlString)"
                        }
                    }),
                    context: name.source() + value.source()))
            }
        }
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
