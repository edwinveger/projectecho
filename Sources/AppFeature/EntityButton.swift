import AppDomain
import SwiftUI

struct EntityButton: View {

    let entity: Entity
    var didTap: () -> Void = { }

    var body: some View {
        Button(action: didTap) {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(16)
                .frame(width: 64, height: 64)
                .background {
                    entity.isOn ? Color.yellow : Color.gray
                }
                .clipShape(Circle())
        }
        .padding()
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

struct EntityButton_Previews: PreviewProvider {

    static var previews: some View {
        HStack {
            EntityButton(entity: .init(id: "bert", name: "preview1", entityType: .fan, isOn: true))
            EntityButton(entity: .init(id: "bert", name: "preview2", entityType: .light, isOn: false))
        }
    }
}
