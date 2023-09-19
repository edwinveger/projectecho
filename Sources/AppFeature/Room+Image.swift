import SwiftUI
import AppDomain

extension Room {

    var image: Image {
        switch self {
        case .bedroom:
            Image(.caramel)
        case .livingRoom:
            Image(.coconut)
        case .bathroom:
            Image(.lemon)
        }
    }
}
