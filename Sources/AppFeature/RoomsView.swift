import SwiftUI
import AppDomain
import Dependencies
import Combine

struct RoomsView: View {

    @ObservedObject var model: RoomsModel

    @State var selectedRoom: Room = .livingRoom

    var body: some View {
        VStack {
            picker

            Toggle(isOn: .constant(true)) {
                Text("Detecteer kamer automatisch")
            }

            Divider()

            ForEach(model.rooms, id: \.id) { room in
                if room.room == selectedRoom {
                    roomView(room)
                }
            }

            Spacer()
        }
        .padding()
    }

    var picker: some View {
        HStack {
            ForEach(Room.allCases, id: \.self) {
                pickerButton(
                    text: $0.shortDescription,
                    tag: $0,
                    isSelected: selectedRoom == $0
                )
                .padding(.horizontal, 8)
            }
        }
    }

    func pickerButton(text: String, tag: Room, isSelected: Bool) -> some View {
        Button {
            selectedRoom = tag
        } label: {
            Text(text)
                .circled(filled: isSelected)
        }
        .buttonStyle(.plain)
    }

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    func roomView(_ room: RoomInstance) -> some View {
        VStack {
            Text(room.room.description)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: columns) {
                ForEach(room.entities, id: \.id) { entity in
                    VStack {
                        EntityButton(entity: entity) {
                            model.didTapEntity(id: entity.id)
                        }
                        Text(entity.id)
                            .font(.system(size: 14))
                    }

                }
            }
        }
        .padding(.bottom)
    }
}

private extension Text {

    func circled(filled: Bool = false) -> some View {
        self
            .padding(8)
            .background {
                if filled {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray)
                        .opacity(0.5)
                } else {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray)
                }
            }
    }
}

struct RoomsView_Previews: PreviewProvider {

    static var previews: some View {
        RoomsView(model: RoomsModel())
    }
}

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

final class RoomsModel: ObservableObject {

    @Dependency(\.observeRoomInstances) var roomInstances
    private var cancellables: [AnyCancellable] = []

    @Published var rooms: [RoomInstance] = []

    init() {
        roomInstances.publisher
            .sink { [weak self] rooms in
                self?.rooms = rooms
            }
            .store(in: &cancellables)
    }

    func didTapEntity(id: String)  {
        let entities = rooms.flatMap(\.entities)
        guard let entity = entities.first(where: { $0.id == id }) else { return }
        roomInstances.toggle(entity: entity, value: !entity.isOn)
    }
}
