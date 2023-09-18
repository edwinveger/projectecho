import AppDomain
import Combine

public class BLERepository {

    let dataSource: BLEDataSourceProtocol

    private var cancellables: [AnyCancellable] = []

    public init(dataSource: BLEDataSourceProtocol) {
        self.dataSource = dataSource

         dataSource.observe()
            .sink { [weak self] in
                self?.process($0)
            }
            .store(in: &cancellables)
    }

    func process(_ observations: [BeaconObservation]) {
        print("BLERepository received \(observations.count) obs.")
    }
}

extension BLERepository: ObserveNearbyRoomsProtocol {

    public var publisher: AnyPublisher<[Room], Never> {
        Just([.bedroom1])
            .eraseToAnyPublisher()
    }
}
