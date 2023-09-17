import ComposableArchitecture

public struct RoomControls: Reducer {

    public struct State: Equatable {

        public init() { }
    }

    public struct Action: Equatable {

    }

    public init() { }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
