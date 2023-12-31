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
        case inspectorUWB
        case inspectorBLE
        case fft
    }

    struct State: Equatable {
        var selectedTab: SelectedTab = .roomsUWB

        // MARK: Child state
        var roomControlsUWBState = RoomControls.State(isUWBEnabled: true)
        var roomControlsBLEState = RoomControls.State(isUWBEnabled: false)
        var inspectorUWBState = Inspector.State(isUWBEnabled: true)
        var inspectorBLEState = Inspector.State(isUWBEnabled: false)
    }

    enum Action: Equatable {
        case didSelectTab(SelectedTab)

        // MARK: Child actions
        case roomsUWB(RoomControls.Action)
        case roomsBLE(RoomControls.Action)
        case inspectorUWB(Inspector.Action)
        case inspectorBLE(Inspector.Action)
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
            case .inspectorUWB:
                return .none
            case .inspectorBLE:
                return .none
            }
        }
    }

    var body: some Reducer<State, Action> {
        _Reducer()

        Scope(
            state: \.roomControlsUWBState,
            action: /Action.roomsUWB
        ) {
            RoomControls()
        }

        Scope(
            state: \.roomControlsBLEState,
            action: /Action.roomsBLE
        ) {
            RoomControls()
        }

        Scope(
            state: \.inspectorUWBState,
            action: /Action.inspectorUWB
        ) {
            Inspector()
        }

        Scope(
            state: \.inspectorBLEState,
            action: /Action.inspectorBLE
        ) {
            Inspector()
        }
    }
}
