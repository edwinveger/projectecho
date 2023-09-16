extension Array {

    public mutating func modify(
        where predicate: (Element) -> Bool = { _ in true },
        closure: (inout Element) -> Void
    ) {
        self = self.map {
            if predicate($0) {
                var value = $0
                closure(&value)
                return value
            } else {
                return $0
            }
        }
    }
}
