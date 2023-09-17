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
    }

    struct State: Equatable {
        var selectedTab: SelectedTab = .rooms

        // MARK: Child state
        var roomControlsState = RoomControls.State()
    }

    enum Action: Equatable {
        case didSelectTab(SelectedTab)

        // MARK: Child actions
        case rooms(RoomControls.Action)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didSelectTab(let tab):
            state.selectedTab = tab
            return .none
        case .rooms:
            return .none
        }
    }
}
