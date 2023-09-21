import Combine
import Dependencies

public protocol ObserveNearbyRoomsProtocol: Activatable {

    /// Emits a set of rooms along with a confidence value.
    var publisher: AnyPublisher<[NearbyRoom], Never> { get }
}

// MARK: - BLE

private struct ObserveNearbyRoomsBLEKey: TestDependencyKey {

    typealias Value = ObserveNearbyRoomsProtocol

    public static let previewValue = PreviewObserveNearbyRoomsBLEService() as Value
    public static let testValue = PreviewObserveNearbyRoomsBLEService() as Value
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

    public static let previewValue = PreviewObserveNearbyRoomsUWBService() as Value
    public static let testValue = PreviewObserveNearbyRoomsUWBService() as Value
}

extension DependencyValues {

    public var observeNearbyRoomsUWB: ObserveNearbyRoomsProtocol {
        get { self[ObserveNearbyRoomsUWBKey.self] }
        set { self[ObserveNearbyRoomsUWBKey.self] = newValue }
    }
}

// MARK: - Previews

private class PreviewObserveNearbyRoomsUWBService: ObserveNearbyRoomsProtocol {

    var isActive: Bool = false

    public func activate() {
        guard !isActive else { return print("DS already active.") }
        isActive = true
    }

    public func deactivate() {
        guard isActive else { return print("DS not active.") }
        isActive = false
    }

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

private class PreviewObserveNearbyRoomsBLEService: ObserveNearbyRoomsProtocol {

    var isActive: Bool = false

    public func activate() {
        guard !isActive else { return print("DS already active.") }
        isActive = true
    }

    public func deactivate() {
        guard isActive else { return print("DS not active.") }
        isActive = false
    }

    let subject = CurrentValueSubject<[NearbyRoom], Never>(
        [
            .init(room: .bathroom, rssi: -5),
            .init(room: .livingRoom, rssi: -10),
            .init(room: .bedroom, rssi: -15)
        ]
    )

    var publisher: AnyPublisher<[NearbyRoom], Never> {
        subject.eraseToAnyPublisher()
    }
}

