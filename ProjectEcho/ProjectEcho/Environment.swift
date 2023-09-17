import AppData
import AppDomain

struct Environment {

    static let shared = Self()

    let observeNearbyRooms: ObserveNearbyRoomsProtocol

    init() {
        observeNearbyRooms = RoomDetectorRepository()
        print("Environment is ready.")
    }
}

