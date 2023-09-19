//
//  ProjectEchoAppReducer.swift
//  ProjectEcho
//
//  Created by Edwin on 17/09/2023.
//

import AppFeature
import ComposableArchitecture

struct Root: Reducer {

    enum SelectedTab: Equatable {
        case roomsUWB
        case roomsBLE
        case arduino
        case estimote
        case inspector
        case fft
    }

    struct State: Equatable {
        var selectedTab: SelectedTab = .roomsUWB

        // MARK: Child state
        var roomControlsUWBState = RoomControls.State()
        var roomControlsBLEState = RoomControls.State()
        var inspectorState = Inspector.State()
    }

    enum Action: Equatable {
        case didSelectTab(SelectedTab)

        // MARK: Child actions
        case roomsUWB(RoomControls.Action)
        case roomsBLE(RoomControls.Action)
        case inspector(Inspector.Action)
    }

    private struct _Reducer: Reducer {

        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            switch action {
            case .didSelectTab(let tab):
                state.selectedTab = tab
                return .none
            case .roomsUWB:
                return .none
            case .roomsBLE:
                return .none
            case .inspector(let action):
                _ = action
                return .none
            }
        }
    }

    var body: some Reducer<State, Action> {
        _Reducer()

        Scope(
            state: \.inspectorState,
            action: /Action.inspector
        ) {
            Inspector()
        }

        Scope(
            state: \.roomControlsUWBState,
            action: /Action.roomsUWB
        ) {
            RoomControls()
                .dependency(\.isUWBEnabled, true)
        }

        Scope(
            state: \.roomControlsBLEState,
            action: /Action.roomsBLE
        ) {
            RoomControls()
                .dependency(\.isUWBEnabled, false)
        }
    }
}
