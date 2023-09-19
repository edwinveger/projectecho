import ComposableArchitecture
import AppDomain
import SwiftUI

public struct InspectorView: View {

    let store: StoreOf<Inspector>

    public init(store: StoreOf<Inspector>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: \.rooms) { viewStore in
            VStack {
                Text("Inspector")
                Divider()
                ForEach(viewStore.state, id: \.room) { nearbyRoom in
                    nearbyRoomView(nearbyRoom)
                }
            }
            .padding()
            .task { await viewStore.send(.task).finish() }
        }
        .tabItem {
            Label("Inspector", systemImage: "waveform.and.magnifyingglass")
        }
    }

    let measurementFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    func nearbyRoomView(_ nearbyRoom: NearbyRoom) -> some View {
        HStack {
            nearbyRoom.room.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 48, maxHeight: 48)

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
            }
        }
        .font(.system(size: 20))
    }
}

struct InspectorView_Previews: PreviewProvider {

    static let store = StoreOf<Inspector>(
        initialState: .init()
    ) {
        Inspector()
    }

    static var previews: some View {
        InspectorView(store: store)
    }
}
