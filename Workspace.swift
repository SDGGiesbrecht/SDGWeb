/*
 Workspace.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

let configuration = WorkspaceConfiguration()
configuration._applySDGDefaults()

configuration.documentation.currentVersion = Version(1, 0, 0)

configuration.documentation.projectWebsite = URL(string: "https://sdggiesbrecht.github.io/SDGWeb")!
configuration.documentation.documentationURL = URL(string: "https://sdggiesbrecht.github.io/SDGWeb")!
configuration.documentation.api.yearFirstPublished = 2018
configuration.documentation.repositoryURL = URL(string: "https://github.com/SDGGiesbrecht/SDGWeb")!

configuration.documentation.localizations = ["🇨🇦EN"]

configuration.continuousIntegration.skipSimulatorOutsideContinuousIntegration = true
configuration.documentation.api.encryptedTravisCIDeploymentKey = "sQc3HlGZyOj3FG45NC9smhjzb34iUQ4KRU95uBtpnXHLs/AcKE5RkED2ljyLJOIv9Wwzb2LIamfORBpbx4QPVgbdqcoeo7CF97+dw3S/xNH4PoLcLHOriS9idSDAqyRL+tOyGyxAPJ94Vu/+Sfn4z6co94Y2ZAaJc8fzYhYA5gdJxwayUve9aP9lw/vKOIOuENtHPrNz6gBbLgM1b9Jp/QTDk+oZ8zpe9l0/rzf4VmYZtI1VGxJGdC3SQKN+TyaJ7UaqCl+G9JdOjuhuRaclNQrKGsP9u+9nqWu9lAN+P3T7TYJnbSMQ+CGGuuXKxxhNKDM4pgtExdpKNLOo5fvISVN4Oi5YSY0KzDx/f0HtXqo4x92tWqWsZzGYjFoInKqKb/4iga3rNOa4vfOMTSbjxHxaQ4KczW+VhznKCKmipBrij8d9zQOsGdrDpVyTkhTcUZPVNjwThs2u0tgVIz4QYGsCqpi536kNzTVZj0v8+G6i1V5y4zlEda09E40XPOizwAZu/qrjAblE2GkL8P1/FADah0ULucQ+mjKZO/afrbmPYCAKDOUqlwUcV+Cd+BOr2ZnGR3TTOZ+mUoyBivPs7ewjTXqt1CwYuia0BgYUqrbupcb895XWeLvRy0mAjjqu4kArMwTiwjeT6rJtdtTW8YzUIqscOtWUcN7zVKkUGKI="

configuration._applySDGOverrides()
configuration._validateSDGStandards()

configuration.repository.ignoredPaths.insert("Tests/Mock Projects")
