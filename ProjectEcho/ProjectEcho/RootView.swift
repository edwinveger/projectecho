//
//  RootView.swift
//  ProjectEcho
//
//  Created by Edwin on 17/09/2023.
//

import SwiftUI
//import AppData
import AppFeature
import ComposableArchitecture

struct RootView: View {

    let store: StoreOf<Root>

    var body: some View {
        WithViewStore(store, observe: \.selectedTab) {
            TabView(
                selection: $0.binding(send: Root.Action.didSelectTab)
            ) {
                RoomControlsView(
                    store: store.scope(
                        state: \.roomControlsUWBState,
                        action: Root.Action.roomsUWB
                    )
                )
                .tag(Root.SelectedTab.roomsUWB)

                RoomControlsView(
                    store: store.scope(
                        state: \.roomControlsBLEState,
                        action: Root.Action.roomsBLE
                    )
                )
                .tag(Root.SelectedTab.roomsBLE)

                InspectorView(
                    store: store.scope(
                        state: \.inspectorState,
                        action: Root.Action.inspector
                    )
                )
                .tag(Root.SelectedTab.inspector)

                // ArduinoBeaconView()
                //     .tag(Root.SelectedTab.arduino)
                // EstimoteView()
                //     .tag(Root.SelectedTab.estimote)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {

    static let previewStore: StoreOf<Root> = Store (
        initialState: Root.State()
    ) {
        Root()
            ._printChanges()
    }

    static var previews: some View {
        RootView(store: previewStore)
    }
}
