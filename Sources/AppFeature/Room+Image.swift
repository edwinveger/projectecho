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

    var bleColor: Color {
        switch self {
        case .bathroom:
            .red
        case .bedroom:
            .green
        case .livingRoom:
            .blue
        }
    }

    var bleImage: some View {
        Image(systemName: "circle.inset.filled")
            .resizable()
            .foregroundColor(bleColor)
    }
}
