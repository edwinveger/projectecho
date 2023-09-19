import Combine
import Dependencies

/// Represents a detected, nearby room.
public struct NearbyRoom: Equatable {

    public let room: Room
    /// Distance in meters.
    public let distance: Float?

    public let rssi: Float?

    public init(
        room: Room,
        distance: Float? = nil,
        rssi: Float? = nil
    ) {
        self.room = room
        self.distance = distance
        self.rssi = rssi
    }
}

public protocol ObserveNearbyRoomsProtocol {

    /// Emits a set of rooms along with a confidence value.
    var publisher: AnyPublisher<[NearbyRoom], Never> { get }
}

// MARK: - BLE

private struct ObserveNearbyRoomsBLEKey: TestDependencyKey {

    typealias Value = ObserveNearbyRoomsProtocol

    public static let previewValue = PreviewObserveNearbyRoomsService() as Value
    public static let testValue = PreviewObserveNearbyRoomsService() as Value
}

extension DependencyValues {

    public var observeNearbyRoomsBLE: ObserveNearbyRoomsProtocol {
        get { self[ObserveNearbyRoomsBLEKey.self] }
        set { self[ObserveNearbyRoomsBLEKey.self] = newValue }
    }
}

// MARK: - UWB

private struct ObserveNearbyRoomsUWBKey: TestDependencyKey {

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

    let subject = CurrentValueSubject<[NearbyRoom], Never>(
        [
            .init(room: .bathroom, distance: 5),
            .init(room: .livingRoom, distance: 10),
            .init(room: .bedroom, distance: 15)
        ]
    )

    var publisher: AnyPublisher<[NearbyRoom], Never> {
        subject.eraseToAnyPublisher()
    }
}
