import ComposableArchitecture
import AppDomain

public struct Inspector: Reducer {

    public struct State: Equatable {

        var rooms: [Room] = []

        public init() { }
    }

    public enum Action: Equatable {

        case task

        // publishers
        case didReceiveRooms([Room])
    }

    public init() { }

    @Dependency(\.observeNearbyRoomsUWB) var observeNearbyRooms

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .task:
            return .run { send in
              for await rooms in observeNearbyRooms.publisher.values {
                await send(.didReceiveRooms(rooms))
              }
            }
        case .didReceiveRooms(let rooms):
            state.rooms = rooms
            return .none
        default:
            return .none
        }
    }
}
