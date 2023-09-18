import ComposableArchitecture
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
                ForEach(viewStore.state, id: \.self) { room in
                    Text(room.description)
                }
            }
            .padding()
            .task { await viewStore.send(.task).finish() }
        }
        .tabItem {
            Label("Inspector", systemImage: "waveform.and.magnifyingglass")
        }
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
