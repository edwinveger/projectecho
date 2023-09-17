import SwiftUI
import ComposableArchitecture

public struct RoomControlsView: View {

    let store: StoreOf<RoomControls>

    public init(store: StoreOf<RoomControls>) {
        self.store = store
    }

    public var body: some View {
        Text("room controls!")
            .tabItem {
                Label("Room controls", systemImage: "square.and.arrow.down")
            }
    }
}
