import AppDomain
import Combine

public class EstimoteRepository {

    let dataSource: EstimoteDataSourceProtocol

    public init(dataSource: EstimoteDataSourceProtocol) {
        self.dataSource = dataSource
    }
}

extension EstimoteRepository: ObserveNearbyRoomsProtocol {

    public var isActive: Bool { dataSource.isActive }
    public func activate() { dataSource.activate() }
    public func deactivate() { dataSource.deactivate() }

    public var publisher: AnyPublisher<[NearbyRoom], Never> {
        dataSource
            .observe()
            .map {
                $0
                    .sorted { $0.distance < $1.distance }
                    .compactMap(\.model)
            }
            // .print("[E Repo]")
            .eraseToAnyPublisher()
    }
}

extension EstimoteObservation {

    var model: NearbyRoom? {
        guard let room = self.room else { return nil }

        return .init(room: room, distance: distance)
    }

    private var room: Room? {
        switch id {
        case "f37e1c1ac2d33623e1d828a83fbc9a2c":
            // CARAMEL
            return .bedroom
        case "f8cc24e7efd6408d21bd000646bcc618":
            // COCONUT
            return .livingRoom
        case "923cc99531a1e2b741497ea9b75d7425":
            // LEMON
            return .bathroom
        default:
            return nil
        }
    }
}
