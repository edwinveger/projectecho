public enum Room: CaseIterable, CustomStringConvertible {

    case bedroom1
    case bedroom2
    case livingRoom
    case bathroom

    public var description: String {
        switch self {
        case .bedroom1:   return "Slaapkamer #1"
        case .bedroom2:   return "Slaapkamer #2"
        case .livingRoom: return "Woonkamer"
        case .bathroom:   return "Badkamer"
        }
    }

    public var shortDescription: String {
        switch self {
        case .bedroom1:   return "SK1"
        case .bedroom2:   return "SK2"
        case .livingRoom: return "WOON"
        case .bathroom:   return "BAD"
        }
    }
}
