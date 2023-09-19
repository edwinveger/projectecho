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
        case rooms
        case arduino
        case estimote
        case inspector
    }

    struct State: Equatable {
        var selectedTab: SelectedTab = .rooms

        // MARK: Child state
        var roomControlsState = RoomControls.State()
        var inspectorState = Inspector.State()
    }

    enum Action: Equatable {
        case didSelectTab(SelectedTab)

        // MARK: Child actions
        case rooms(RoomControls.Action)
        case inspector(Inspector.Action)
    }

    private struct _Reducer: Reducer {

        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            switch action {
            case .didSelectTab(let tab):
                state.selectedTab = tab
                return .none
            case .rooms:
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
            state: \.roomControlsState,
            action: /Action.rooms
        ) {
            RoomControls()
        }
    }
}
