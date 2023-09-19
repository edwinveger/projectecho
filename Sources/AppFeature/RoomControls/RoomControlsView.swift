import SwiftUI
import ComposableArchitecture
import AppDomain

public struct RoomControlsView: View {

    let store: StoreOf<RoomControls>

    public init(store: StoreOf<RoomControls>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    ForEach(viewStore.rooms, id: \.id) { room in
                        if room.room == viewStore.selectedRoom {
                            roomView(room)
                        }
                    }

                    .padding()
                    VStack(spacing: 24) {
                        picker
                        
                        Toggle(
                            isOn: viewStore.binding(
                                get: \.isAutoSwitchingEnabled,
                                send: RoomControls.Action.didToggleAutoSwitching
                            )
                        ) {
                            Text("Detecteer kamer automatisch")
                        }
                    }
                    .padding()
                    .background { Color.gray.opacity(0.05) }

                }
                .navigationTitle(title)
            }
            .task {
                await store.send(.task).finish()
            }
            .tabItem {
                Label("\(title)", systemImage: "wifi.circle")
            }
        }
    }

    private var title: String {
        if isUWBEnabled {
            "BLE + UWB"
        } else {
            "BLE only"
        }
    }

    private var isUWBEnabled: Bool {
        ViewStore(store, observe: \.isUWBEnabled).state
    }

    private var picker: some View {
        WithViewStore(store, observe: \.selectedRoom) { viewStore in
            Picker("Topping", selection: viewStore.binding(send: RoomControls.Action.didTapRoom)) {
                ForEach(Room.allCases, id: \.self) { topping in
                    Text(topping.shortDescription)
                }
            }
            .pickerStyle(.segmented)
        }
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

            Spacer()

            if isUWBEnabled {
                room.room.image
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
//            .dependency(\.isUWBEnabled, true)
    }

    static var previews: some View {
        TabView {
            RoomControlsView(store: store)
            Text("second")
                .tabItem {
                    Label("Other", systemImage: "square.and.arrow.down")
                }
        }
    }
}
