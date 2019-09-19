

/// A node which has associated content, either directly or through one of its children.
public protocol ContainerSyntax : Syntax {
    var content: ListSyntax<ContentSyntax> { get set }
}
