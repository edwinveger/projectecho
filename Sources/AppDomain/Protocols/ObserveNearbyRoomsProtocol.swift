import Combine
import Dependencies

public protocol ObserveNearbyRoomsProtocol {

    /// Emits a set of rooms along with a confidence value.
    var publisher: AnyPublisher<[Room], Never> { get }
}

// MARK: - BLE

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

// MARK: - UWB

struct ObserveNearbyRoomsUWBKey: TestDependencyKey {

    typealias Value = ObserveNearbyRoomsProtocol

    public static let previewValue = PreviewObserveNearbyRoomsService() as Value
    public static let testValue = PreviewObserveNearbyRoomsService() as Value
}

extension DependencyValues {

    public var observeNearbyRoomsUWB: ObserveNearbyRoomsProtocol {
        get { self[ObserveNearbyRoomsUWBKey.self] }
        set { self[ObserveNearbyRoomsUWBKey.self] = newValue }
    }
}

// MARK: - Previews

private struct PreviewObserveNearbyRoomsService: ObserveNearbyRoomsProtocol {

    let subject = CurrentValueSubject<[Room], Never>(
        [
            .bathroom,
            .livingRoom,
            .bedroom1
        ]
    )

    var publisher: AnyPublisher<[Room], Never> {
        subject.eraseToAnyPublisher()
    }
}
