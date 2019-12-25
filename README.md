<!--
 README.md

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 -->

macOS • Linux • iOS • watchOS • tvOS

[Documentation](https://sdggiesbrecht.github.io/SDGWeb/%F0%9F%87%A8%F0%9F%87%A6EN)

# SDGWeb

SDGWeb provides tools for generating websites.

> [כְּשִׁמְךָ אֱלֹהִים כְּן תְּהלָּתְךָ עַל־קַצְוֵי־אֶרֶץ׃](https://www.biblegateway.com/passage/?search=Psalm+48&version=WLC;NIV)
>
> [Like your name, O God, your praise reaches to the ends of the earth.](https://www.biblegateway.com/passage/?search=Psalm+48&version=WLC;NIV)
>
> ―sons of קורח/Koraẖ

### Features:

- Sites are constructed from simple templates.
- Customizable template processing in Swift.
- Supports localized websites.

### Example Usage

```swift
let mock = RepositoryStructure(
  root: URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appendingPathComponent("Mock Projects/\(mockName)")
)

let site = Site<L>(
  repositoryStructure: mock,
  domain: UserFacing<StrictString, L>({ _ in return "http://example.com" }),
  localizationDirectories: UserFacing<StrictString, L>({ localization in
    return localization.icon ?? StrictString(localization.code)
  }),
  author: UserFacing<ElementSyntax, L>({ _ in
    return .author("John Doe", language: InterfaceLocalization.englishCanada)
  }),
  pageProcessor: Processor(),
  reportProgress: { _ in }
)

try site.generate().get()
let warnings = site.validate()
```

## Importing

SDGWeb provides libraries for use with the [Swift Package Manager](https://swift.org/package-manager/).

Simply add SDGWeb as a dependency in `Package.swift` and specify which of the libraries to use:

```swift
let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGWeb", from: Version(4, 0, 1)),
    ],
    targets: [
        .target(name: "MyTarget", dependencies: [
            .productItem(name: "SDGWeb", package: "SDGWeb"),
            .productItem(name: "SDGHTML", package: "SDGWeb"),
            .productItem(name: "SDGCSS", package: "SDGWeb"),
        ])
    ]
)
```

The modules can then be imported in source files:

```swift
import SDGWeb
import SDGHTML
import SDGCSS
```

## About

The SDGWeb project is maintained by Jeremy David Giesbrecht.

If SDGWeb saves you money, consider giving some of it as a [donation](https://paypal.me/JeremyGiesbrecht).

If SDGWeb saves you time, consider devoting some of it to [contributing](https://github.com/SDGGiesbrecht/SDGWeb) back to the project.

> [Ἄξιος γὰρ ὁ ἐργάτης τοῦ μισθοῦ αὐτοῦ ἐστι.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)
>
> [For the worker is worthy of his wages.](https://www.biblegateway.com/passage/?search=Luke+10&version=SBLGNT;NIV)
>
> ―‎ישוע/Yeshuʼa
