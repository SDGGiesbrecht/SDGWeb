/*
 AttributeSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import SDGLocalization

import SDGWebLocalizations

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
            return AttributeSyntax(_storage: SyntaxStorage(children: [
                TokenSyntax.parseWhitespace(fromEndOf: &source),
                name,
                value
                ]))
        }
    }

    // MARK: - Children

    public var whitespace: TokenSyntax {
        return _storage.children[AttributeSyntax.indices[.whitespace]!] as! TokenSyntax
    }

    public var name: TokenSyntax {
        return _storage.children[AttributeSyntax.indices[.name]!] as! TokenSyntax
    }

    public var value: AttributeValueSyntax? {
        return _storage.children[AttributeSyntax.indices[.value]!] as? AttributeValueSyntax
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
        "dir",
        "charset",
        "href",
        "lang",
        "rel"
    ]
    private static let emptyAttributes: Set<String> = [
        "html" // DOCTYPE
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
                    context: source()))
            }
        } else if name ∈ AttributeSyntax.emptyAttributes {
            if value ≠ nil {
                results.append(SyntaxError(
                    file: file,
                    index: location,
                    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "An attribute has an invalid value."
                        }

                    }),
                    context: source()))
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
                context: source()))
        }
    }

    private static let urlAttributes: Set<String> = ["href", "src"]
    internal func validateURLValue(
        location: String.ScalarView.Index,
        file: String,
        baseURL: URL,
        results: inout [SyntaxError]) {
        if name.source() ∈ AttributeSyntax.urlAttributes,
            let urlString = value?.value.source() {
            if let url = URL(string: urlString, relativeTo: baseURL) {
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
                        if error ≠ nil,
                            let status = (response as? HTTPURLResponse)?.statusCode,
                            status.dividedAccordingToEuclid(by: 100) ≠ 2 {
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
                                return "A link is dead: \(urlString)"
                            }
                        }),
                        context: source()))
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
                    context: source()))
            }
        }
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
