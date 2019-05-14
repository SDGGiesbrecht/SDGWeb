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
import SDGHTML

extension AttributeSyntax {

    private static let nonEmptyAttributes: Set<String> = []
    private static let emptyAttributes: Set<String> = []

    private static let urlAttributes: Set<String> = ["href", "src"]

    internal func validate(location: String.ScalarView.Index, parentFile: String) -> [SiteValidationError] {
        var result: [SiteValidationError] = []
        let name = self.name.source()

        if name ∈ AttributeSyntax.nonEmptyAttributes {
            if value == nil {
                result.append(SiteValidationError.syntaxError(SyntaxError(
                    file: parentFile,
                    index: location,
                    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "An attribute value is missing."
                        }

                    }),
                    context: source())))
            }
        } else if name ∈ AttributeSyntax.emptyAttributes {
            if value ≠ nil {
                result.append(SiteValidationError.syntaxError(SyntaxError(
                    file: parentFile,
                    index: location,
                    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "An attribute has an invalid value."
                        }

                    }),
                    context: source())))
            }
        } else {
            result.append(SiteValidationError.syntaxError(SyntaxError(
                file: parentFile,
                index: location,
                description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Unknown attribute."
                    }

                }),
                context: source())))
        }

        if name ∈ AttributeSyntax.urlAttributes {
            if let url = value?.value.source() {

            } else {
                // No value.

            }
        }
        return result
    }
}

private func checkLinks(in node: XMLNode, file: URL) -> [Error] {
    var results: [Error] = []

    if let element = node as? XMLElement {
        for attribute in ["href", "src"] {
            if let link = element.attribute(forName: attribute),
                let urlString = link.stringValue {
                if let url = URL(string: urlString, relativeTo: file) {
                    var dead = true
                    if url.isFileURL {
                        if (try? url.checkResourceIsReachable()) == true {
                            dead = false
                        }
                    } else {
                        dead = false
                    }
                    if dead {
                        results.append(ValidationError(description: UserFacing({ localization in
                            switch localization {
                            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                                return [
                                    "Dead link:",
                                    StrictString(urlString)
                                ]
                            }
                        })))
                    }
                } else {
                    results.append(ValidationError(description: UserFacing({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return [
                                "Invalid URL:",
                                StrictString(urlString)
                            ]
                        }
                    })))
                }
            }
        }
    }

    for child in node.children ?? [] {
        results += checkLinks(in: child, file: file)
    }
    return results
}
