import Combine
import Dependencies

public protocol ObserveNearbyRoomsProtocol {

    /// Emits a set of rooms along with a confidence value.
    var publisher: AnyPublisher<[Room], Never> { get }
}

struct ObserveNearbyRoomsKey: TestDependencyKey {

    typealias Value = ObserveNearbyRoomsProtocol

    public static let previewValue = PreviewObserveNearbyRoomsService() as Value
    public static let testValue = PreviewObserveNearbyRoomsService() as Value
}

extension DependencyValues {

    public var observeNearbyRooms: ObserveNearbyRoomsProtocol {
        get { self[ObserveNearbyRoomsKey.self] }
        set { self[ObserveNearbyRoomsKey.self] = newValue }
    }
}

private struct PreviewObserveNearbyRoomsService: ObserveNearbyRoomsProtocol {

    let subject = CurrentValueSubject<[Room], Never>([])

    var publisher: AnyPublisher<[Room], Never> {
        subject.eraseToAnyPublisher()
    }
}
