import Combine
import Dependencies

public protocol ObserveRoomInstancesProtocol {

    var publisher: AnyPublisher<[RoomInstance], Never> { get }
    func toggle(entity: Entity, value: Bool)
}

struct ObserveRoomInstancesKey: TestDependencyKey {

    typealias Value = ObserveRoomInstancesProtocol

    public static let previewValue = PreviewRoomInstanceService() as Value
    public static let testValue = PreviewRoomInstanceService() as Value
}

extension DependencyValues {

    public var observeRoomInstances: ObserveRoomInstancesProtocol {
        get { self[ObserveRoomInstancesKey.self] }
        set { self[ObserveRoomInstancesKey.self] = newValue }
    }
}

private struct PreviewRoomInstanceService: ObserveRoomInstancesProtocol {

    let subject = CurrentValueSubject<[RoomInstance], Never>(.preview)

    var publisher: AnyPublisher<[RoomInstance], Never> {
        subject.eraseToAnyPublisher()
    }

    func toggle(entity: Entity, value: Bool) {
        var state = subject.value

        state.modify { roomInstance in
            roomInstance.entities.modify(
                where: { $0.id == entity.id },
                closure: { $0.isOn = value }
            )
        }

        subject.send(state)
    }
}

extension Array<RoomInstance> {

    static var preview: Self {
        let bathroom = RoomInstance(
            room: .bathroom,
            entities: [
                .init(id: "bath1", entityType: .light, isOn: false),
                .init(id: "bath_fan_1", entityType: .fan, isOn: false)
            ]
        )

        let bedroom1 = RoomInstance(
            room: .bedroom1,
            entities: [
                .init(id: "bed1_light_1", entityType: .light, isOn: false),
                .init(id: "bed1_light_2", entityType: .light, isOn: false),
                .init(id: "bed1_light_3", entityType: .light, isOn: false)
            ]
        )

        let bedroom2 = RoomInstance(
            room: .bedroom2,
            entities: [
                .init(id: "bed2_light_1", entityType: .light, isOn: false)
            ]
        )

        let livingRoom = RoomInstance(
            room: .livingRoom,
            entities: [
                .init(id: "living1_light_1", entityType: .light, isOn: true),
                .init(id: "living1_light_2", entityType: .light, isOn: false),
                .init(id: "living1_light_3", entityType: .light, isOn: true),
                .init(id: "living1_light_4", entityType: .light, isOn: false),
                .init(id: "living1_fan_1", entityType: .fan, isOn: false)
            ]
        )

        return [
            bathroom,
            bedroom1,
            bedroom2,
            livingRoom
        ]
    }
}
