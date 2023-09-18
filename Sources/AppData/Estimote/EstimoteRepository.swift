import AppDomain
import Combine
import EstimoteProximitySDK

public class EstimoteRepository {

    let dataSource: EstimoteDataSourceProtocol

    public init(dataSource: EstimoteDataSourceProtocol) {
        self.dataSource = dataSource


    }
}

extension EstimoteRepository: ObserveNearbyRoomsProtocol {

    public var publisher: AnyPublisher<[Room], Never> {
        Just([])
            .eraseToAnyPublisher()
    }
}
