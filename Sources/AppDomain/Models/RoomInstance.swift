import Foundation

public enum EntityType: Equatable {
    case light
    case fan
}

public struct Entity: Equatable {

    public init(
        id: String,
        name: String,
        entityType: EntityType,
        isOn: Bool
    ) {
        self.id = id
        self.name = name
        self.entityType = entityType
        self.isOn = isOn
    }

    public let id: String
    public let name: String
    public let entityType: EntityType
    public var isOn: Bool
}

public struct RoomInstance: Equatable {

    public init(
        room: Room,
        entities: [Entity]
    ) {
        self.room = room
        self.entities = entities
    }

    public let id = UUID()
    public let room: Room
    public var entities: [Entity]
}
