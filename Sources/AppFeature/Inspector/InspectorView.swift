import ComposableArchitecture
import AppDomain
import SwiftUI

public struct InspectorView: View {

    let store: StoreOf<Inspector>

    public init(store: StoreOf<Inspector>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    ForEach(viewStore.rooms, id: \.room) { nearbyRoom in
                        nearbyRoomView(nearbyRoom, isUWB: viewStore.isUWBEnabled)
                        Divider()
                    }
                    Spacer()
                }
                .padding()
                .task { await viewStore.send(.task).finish() }
                .navigationTitle(viewStore.isUWBEnabled ? "Inspector UWB" : "Inspector BLE")
            }

            .tabItem {
                Label(
                    viewStore.isUWBEnabled ? "Inspector UWB" : "Inspector BLE",
                    systemImage: "waveform.and.magnifyingglass"
                )
            }
        }
    }

    private let measurementFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    private let rssiFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.maximumFractionDigits = 0
        return f
    }()

    func nearbyRoomView(_ nearbyRoom: NearbyRoom, isUWB: Bool) -> some View {
        HStack {
            if isUWB {
                nearbyRoom.room.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 48, maxHeight: 48)
            } else {
                Image(systemName: "circle.inset.filled")
                    .frame(maxWidth: 48, maxHeight: 48)
                    .foregroundColor(nearbyRoom.room.color)
            }

            Text(nearbyRoom.room.description)

            Spacer()

            if let distance = nearbyRoom.distance {
                Text(
                    (
                        measurementFormatter.string(
                        from: NSNumber(value: distance)
                    ) ?? ""
                        ) + " m."
                )
            } else if let rssi = nearbyRoom.rssi {
                Text("RSSI: \(Int(rssi))")
            }
        }
        .font(.system(size: 20))
    }
}

struct InspectorView_Previews: PreviewProvider {

    static let store = StoreOf<Inspector>(
        initialState: .init(isUWBEnabled: false)
    ) {
        Inspector()
    }

    static var previews: some View {
        TabView {
            InspectorView(store: store)
        }
    }
}
