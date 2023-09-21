public enum Room: CaseIterable, CustomStringConvertible, Equatable {

    case bathroom
    case bedroom
    case livingRoom

    public var description: String {
        switch self {
        case .bathroom:   return "Badkamer"
        case .bedroom:   return "Slaapkamer"
        case .livingRoom: return "Woonkamer"
        }
    }

    public var shortDescription: String {
        switch self {
        case .bathroom:   return "BAD"
        case .bedroom:   return "SLAAP"
        case .livingRoom: return "WOON"
        }
    }
}
