import SwiftUI
import ComposableArchitecture
import AppDomain

public struct RoomControlsView: View {

    let store: StoreOf<RoomControls>

    public init(store: StoreOf<RoomControls>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            picker

            WithViewStore(store, observe: \.isAutoSwitchingEnabled) {
                Toggle(isOn: $0.binding(send: RoomControls.Action.didToggleAutoSwitching)) {
                    Text("Detecteer kamer automatisch")
                }
            }

            Divider()

            WithViewStore(store, observe: { $0 }) { viewStore in
                ForEach(viewStore.rooms, id: \.id) { room in
                    if room.room == viewStore.selectedRoom {
                        roomView(room)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .tabItem {
            Label("Room controls", systemImage: "square.and.arrow.down")
        }
        .task {
            await store.send(.task).finish()
        }
    }

    var picker: some View {
        HStack {
            WithViewStore(store, observe: \.selectedRoom) { viewStore in
                ForEach(Room.allCases, id: \.self) {
                    pickerButton(
                        text: $0.shortDescription,
                        tag: $0,
                        isSelected: viewStore.state == $0
                    )
                    .padding(.horizontal, 8)
                }
            }
        }
    }

    func pickerButton(text: String, tag: Room, isSelected: Bool) -> some View {
        Button {
            store.send(.didTapRoom(tag))
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
                                store.send(.didTapEntity(id: entity.id))
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

struct RoomControlsView_Previews: PreviewProvider {

    static let store = StoreOf<RoomControls>(
        initialState: .init()
    ) {
        RoomControls()
    }

    static var previews: some View {
        RoomControlsView(store: store)
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
