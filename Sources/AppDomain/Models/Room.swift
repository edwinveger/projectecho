public enum Room: CaseIterable, CustomStringConvertible, Equatable {

    case bedroom
    case livingRoom
    case bathroom

    public var description: String {
        switch self {
        case .bedroom:   return "Slaapkamer #1"
        case .livingRoom: return "Woonkamer"
        case .bathroom:   return "Badkamer"
        }
    }

    public var shortDescription: String {
        switch self {
        case .bedroom:   return "SK1"
        case .livingRoom: return "WOON"
        case .bathroom:   return "BAD"
        }
    }
}
