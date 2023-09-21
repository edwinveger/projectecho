//
//  RootView.swift
//  ProjectEcho
//
//  Created by Edwin on 17/09/2023.
//

import AppFeature
import ComposableArchitecture
import FFTFeature
import SwiftUI

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

                InspectorView(
                    store: store.scope(
                        state: \.inspectorUWBState,
                        action: Root.Action.inspectorUWB
                    )
                )
                .tag(Root.SelectedTab.inspectorUWB)

                RoomControlsView(
                    store: store.scope(
                        state: \.roomControlsBLEState,
                        action: Root.Action.roomsBLE
                    )
                )
                .tag(Root.SelectedTab.roomsBLE)

                InspectorView(
                    store: store.scope(
                        state: \.inspectorBLEState,
                        action: Root.Action.inspectorBLE
                    )
                )
                .tag(Root.SelectedTab.inspectorBLE)

                // ArduinoBeaconView()
                //     .tag(Root.SelectedTab.arduino)
                // EstimoteView()
                //     .tag(Root.SelectedTab.estimote)

                TunerView()
                    .tabItem {
                        Label("FFT", systemImage: "waveform.path")
                    }
                    .tag(Root.SelectedTab.fft)
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
