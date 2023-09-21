import ComposableArchitecture
import AppDomain

public struct Inspector: Reducer {

    public struct State: Equatable {

        var rooms: [NearbyRoom] = []
        var isUWBEnabled = false

        public init(isUWBEnabled: Bool = false) {
            self.isUWBEnabled = isUWBEnabled
        }
    }

    public enum Action: Equatable {

        case task

        // publishers
        case didReceiveRooms([NearbyRoom])
    }

    public init() { }

    @Dependency(\.observeNearbyRoomsUWB) var observeNearbyRoomsUWB
    @Dependency(\.observeNearbyRoomsBLE) var observeNearbyRoomsBLE

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .task:
            let isUWBEnabled = state.isUWBEnabled

            return .run { send in
                let publisher = if isUWBEnabled {
                    observeNearbyRoomsUWB.publisher
                } else {
                    observeNearbyRoomsBLE.publisher
                }

              for await rooms in publisher.values {
                await send(.didReceiveRooms(rooms))
              }
            }
        case .didReceiveRooms(let rooms):
            state.rooms = rooms
            return .none
        // default:
        //     return .none
        }
    }
}
