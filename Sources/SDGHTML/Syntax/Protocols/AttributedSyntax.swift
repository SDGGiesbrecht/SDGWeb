/*
 AttributedSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A node which has an associated set of attributes, either directly or through one of its children.
public protocol AttributedSyntax: Syntax {

  /// The attributes in dictionary form.
  var attributeDictionary: [String: String] { get set }

  /// Returns the attribute with the specified name.
  ///
  /// - Parameters:
  ///     - name: The name.
  func attribute(named name: String) -> AttributeSyntax?

  /// Applies the attribute.
  ///
  /// If the attribute already exists, it will be overwritten with the new node. Otherwise the new node will be appended to the end of the list.
  ///
  /// - Parameters:
  ///     - attribute: The attribute.
  mutating func apply(attribute: AttributeSyntax)

  /// Removes the attribute with the specified name.
  ///
  /// - Parameters:
  ///     - name: The name.
  mutating func removeAttribute(named name: String)
}

extension AttributedSyntax {

  /// Returns the value of the attribute with the specified name.
  ///
  /// - Parameters:
  ///     - name: The name.
  public func valueOfAttribute(named name: String) -> String? {
    return attribute(named: name)?.valueText
  }

  /// Sets the attribute to the provided value, or removes it if the provided value is `nil`.
  ///
  /// - Parameters:
  ///     - name: The name of the attribute.
  ///     - value: The value of the attribute.
  public mutating func set(attribute name: String, to value: String?) {
    if let insert = value {
      apply(attribute: AttributeSyntax(name: name, value: insert))
    } else {
      removeAttribute(named: name)
    }
  }

  private var identifierName: String { return "id" }
  /// The value of the identifier attribute.
  public var identifier: String? {
    get {
      return valueOfAttribute(named: identifierName)
    }
    set {
      set(attribute: identifierName, to: newValue)
    }
  }

  private var className: String { return "class" }
  /// The entries of the class attribute.
  public var classes: [String] {
    get {
      return valueOfAttribute(named: className)?.components(separatedBy: " ") ?? []
    }
    set {
      set(attribute: className, to: newValue.isEmpty ? nil : newValue.joined(separator: " "))
    }
  }

  private var languageName: String { return "lang" }
  /// The value of the language attribute.
  public var language: String? {
    get {
      return valueOfAttribute(named: languageName)
    }
    set {
      set(attribute: languageName, to: newValue)
    }
  }

  private var textDirectionName: String { return "dir" }
  /// The value of the text direction attribute.
  public var textDirection: String? {
    get {
      return valueOfAttribute(named: textDirectionName)
    }
    set {
      set(attribute: textDirectionName, to: newValue)
    }
  }

  private var translationIntentName: String { return "translate" }
  /// The value of the attribute which declares translation intent.
  public var translationIntentValue: String? {
    get {
      return valueOfAttribute(named: translationIntentName)
    }
    set {
      set(attribute: translationIntentName, to: newValue)
    }
  }
  private var yesValue: String { return "yes" }
  private var noValue: String { return "no" }
  /// The value of the attribute which declares translation intent.
  public var translationIntent: Bool? {
    get {
      switch translationIntentValue {
      case yesValue:
        return true
      case noValue:
        return false
      default:
        return nil
      }
    }
    set {
      var value: String?
      if let new = newValue {
        value = new ? yesValue : noValue
      }
      translationIntentValue = value
    }
  }
}
