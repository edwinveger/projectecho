import Dependencies

private struct IsUWBEnabledKey: TestDependencyKey {

    typealias Value = Bool

    public static let previewValue = true
    public static let testValue = false
}

extension DependencyValues {

    public var isUWBEnabled: Bool {
        get { self[IsUWBEnabledKey.self] }
        set { self[IsUWBEnabledKey.self] = newValue }
    }
}

