/*
 RepositoryStructure.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

/// The structure of a website repository.
public struct RepositoryStructure {

    // MARK: - Initialization

    /// Creates the default structure, assuming this initializer is called from “main.swift” in that file’s default location.
    public init(_main main: String = #file) {
        var url = URL(fileURLWithPath: main)
        for _ in 1 ... 3 {
            url.deleteLastPathComponent()
        }
        self.init(root: url)
    }

    /// Creates a custom repository structure.
    public init(
        root: URL,
        template: URL? = nil,
        result: URL? = nil,
        pages: URL? = nil,
        components: URL? = nil,
        css: URL? = nil,
        frame: URL? = nil,
        siteCSS: URL? = nil) {

        self.root = root

        let resolvedTemplate = template ?? root.appendingPathComponent("Template")
        self.template = resolvedTemplate

        self.result = result ?? root.appendingPathComponent("Result")

        self.pages = pages ?? resolvedTemplate.appendingPathComponent("Pages")
        let resolvedComponents = components ?? resolvedTemplate.appendingPathComponent("Components")
        self.components = resolvedComponents
        let resolvedCSS = css ?? resolvedTemplate.appendingPathComponent("CSS")
        self.css = resolvedCSS

        self.frame = frame ?? resolvedComponents.appendingPathComponent("Frame.html")
        self.siteCSS = siteCSS ?? resolvedCSS.appendingPathComponent("Site.css")
    }

    // MARK: - Properties

    /// The root of the repository.
    public let root: URL

    /// The directory where the user‐managed template files are stored.
    public let template: URL
    /// The directory where the resulting site should be produced.
    public let result: URL

    /// The directory containing the site’s page files.
    public let pages: URL
    /// The directory containing CSS files.
    public let css: URL
    /// The directory containing reusable template components.
    public let components: URL

    /// The file representing the website frame.
    public let frame: URL
    /// The file containing the site’s global CSS.
    public let siteCSS: URL
}
