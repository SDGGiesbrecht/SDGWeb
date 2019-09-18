
public protocol AttributedSyntax : Syntax {

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
    ///     - name: The name.
    mutating func apply(attribute: AttributeSyntax)
}

extension AttributedSyntax {

    /// Returns the value of the attribute with the specified name.
    ///
    /// - Parameters:
    ///     - name: The name.
    public func valueOfAttribute(named name: String) -> String? {
        return attribute(named: name)?.valueText
    }

    /// Sets the attribute to the provided value.
    ///
    /// - Parameters:
    ///     - name: The name of the attribute.
    ///     - value: The value of the attribute.
    public mutating func set(attribute name: String, to value: String?) {
        apply(attribute: AttributeSyntax(name: name, value: value))
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
    /// The value of the class attribute.
    public var `class`: String? {
        get {
            return valueOfAttribute(named: className)
        }
        set {
            set(attribute: className, to: newValue)
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
    public var translationIntent: String? {
        get {
            return valueOfAttribute(named: translationIntentName)
        }
        set {
            set(attribute: translationIntentName, to: newValue)
        }
    }
}
