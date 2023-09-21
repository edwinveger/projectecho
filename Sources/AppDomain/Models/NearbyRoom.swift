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
