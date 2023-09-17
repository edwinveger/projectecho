import AppDomain
import Combine

public struct RoomDetectorRepository {

    public init() {
        
    }
}

extension RoomDetectorRepository: ObserveNearbyRoomsProtocol {

    public var publisher: AnyPublisher<[Room], Never> {
        Just([.bedroom1])
            .eraseToAnyPublisher()
    }
}
