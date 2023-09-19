public enum Room: CaseIterable, CustomStringConvertible, Equatable {

    case bedroom
    case livingRoom
    case bathroom

    public var description: String {
        switch self {
        case .bedroom:   return "Slaapkamer"
        case .livingRoom: return "Woonkamer"
        case .bathroom:   return "Badkamer"
        }
    }

    public var shortDescription: String {
        switch self {
        case .bedroom:   return "SLAAP"
        case .livingRoom: return "WOON"
        case .bathroom:   return "BAD"
        }
    }
}
