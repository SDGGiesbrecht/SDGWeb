protocol ChildSet: CaseIterable, Hashable {}

extension ChildSet {

  internal static func indexTable() -> [Self: Int] {
    var dictionary: [Self: Int] = [:]
    for (index, child) in allCases.enumerated() {
      dictionary[child] = index
    }
    return dictionary
  }
}
