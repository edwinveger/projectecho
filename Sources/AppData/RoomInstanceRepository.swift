import AppDomain
import Combine

public struct RoomInstanceRepository: ObserveRoomInstancesProtocol {

    public init() {

    }

    public var publisher: AnyPublisher<[AppDomain.RoomInstance], Never> { fatalError() }

    public func toggle(entity: AppDomain.Entity, value: Bool) {
        fatalError()
    }
}
