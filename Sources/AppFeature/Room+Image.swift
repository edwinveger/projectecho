import SwiftUI
import AppDomain

extension Room {

    /// Estimote image.
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

    var color: Color {
        switch self {
        case .bathroom:
            .red
        case .bedroom:
            .green
        case .livingRoom:
            .blue
        }
    }
}
