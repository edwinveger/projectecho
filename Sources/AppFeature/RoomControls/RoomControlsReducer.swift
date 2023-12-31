import ComposableArchitecture
import AppDomain

public struct RoomControls: Reducer {

    public struct State: Equatable {

        var selectedRoom: Room = .livingRoom
        var rooms: [RoomInstance] = []
        var isAutoSwitchingEnabled = false
        var isUWBEnabled = false
        var isActive = false

        public init(isUWBEnabled: Bool = false) {
            self.isUWBEnabled = isUWBEnabled
        }
    }

    public enum Action: Equatable {
        case task
        case didTapEntity(id: String)
        case didTapRoom(Room)
        case didTapActivateToggle
        case didToggleAutoSwitching(isEnabled: Bool)
        case didReceiveRooms([RoomInstance])
        case didReceiveNearbyRoom(NearbyRoom)
    }

    public init() { }

    @Dependency(\.observeRoomInstances) var roomInstances
    @Dependency(\.observeNearbyRoomsUWB) var observeNearbyRoomsUWB
    @Dependency(\.observeNearbyRoomsBLE) var observeNearbyRoomsBLE

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .task:
            let observeRoomsEffect: Effect<Action> = .run { send in
                for await rooms in roomInstances.publisher.values {
                    await send(.didReceiveRooms(rooms))
                }
            }

            let isUWBEnabled = state.isUWBEnabled

            let observeNearbyRoomEffect: Effect<Action> = .run { send in
                let publisher = if isUWBEnabled {
                    observeNearbyRoomsUWB.publisher
                } else {
                    observeNearbyRoomsBLE.publisher
                }

                for await nearbyRooms in publisher.values {
                    guard let first = nearbyRooms.first else { continue }
                    await send(.didReceiveNearbyRoom(first))
                }
            }

            return .merge(
                observeRoomsEffect,
                observeNearbyRoomEffect
            )
        case .didTapEntity(let id):
            let entities = state.rooms.flatMap(\.entities)
            if let entity = entities.first(where: { $0.id == id })  {
                roomInstances.toggle(entity: entity, value: !entity.isOn)
            }

            return .none
        case .didTapRoom(let room):
            state.selectedRoom = room
            return .none
        case .didTapActivateToggle:
            let repository: ObserveNearbyRoomsProtocol =
            if state.isUWBEnabled {
                observeNearbyRoomsUWB
            } else {
                observeNearbyRoomsBLE
            }

            repository.isActive ? repository.deactivate() : repository.activate()
            state.isActive = repository.isActive
            return .none
        case .didToggleAutoSwitching(isEnabled: let isEnabled):
            state.isAutoSwitchingEnabled = isEnabled
            return .none
        case .didReceiveRooms(let array):
            state.rooms = array
            return .none
        case .didReceiveNearbyRoom(let nearbyRoom):
            if state.isAutoSwitchingEnabled {
                state.selectedRoom = nearbyRoom.room
            }
            return .none
        }
    }
}
