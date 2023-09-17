import AppDomain
import SwiftUI

struct EntityButton: View {

    let entity: Entity
    var didTap: () -> Void = { }

    var body: some View {
        Button(action: didTap) {
            image
                .frame(width: 48, height: 48)
                .background {
                    entity.isOn ? Color.yellow : Color.gray
                }
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    var image: Image {
        switch (entity.entityType, entity.isOn) {
        case (.light, true):
            return Image(systemName: "lightbulb.fill")
        case (.light, false):
            return Image(systemName: "lightbulb")
        case (.fan, true):
            return Image(systemName: "fanblades.fill")
        case (.fan, false):
            return Image(systemName: "fanblades")
        }
    }
}
