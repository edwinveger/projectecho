import AppDomain
import Combine
import Foundation

public class BLERepository {

    let dataSource: BLEDataSourceProtocol

    private var cancellables: [AnyCancellable] = []

    public init(dataSource: BLEDataSourceProtocol) {
        self.dataSource = dataSource

        dataSource.observe()
            .removeDuplicates()
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] in
                self?.process($0)
            }
            .store(in: &cancellables)

        activate()
    }

    func process(_ observations: [BeaconObservation]) {
//        print("BLERepository received \(observations.count) obs.")
//
//        let sortedObservations = observations.sorted { $0.rssi > $1.rssi }
//
//        for o in sortedObservations {
//            print("\(o.uuid.uuidString) \(o.rssi) \(o.name)")
//        }
    }
}

extension BLERepository: ObserveNearbyRoomsProtocol {

    public var isActive: Bool { dataSource.isActive }
    public func activate() { dataSource.activate() }
    public func deactivate() { dataSource.deactivate() }

    public var publisher: AnyPublisher<[NearbyRoom], Never> {
        //assertionFailure("Not implemented")

        return Just([.init(room: .bedroom)])
            .eraseToAnyPublisher()
    }
}
