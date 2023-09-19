import Combine
import Foundation

public typealias RSSI = Float

public struct BeaconObservation: Equatable {
    let uuid: UUID
    let name: String
    let rssi: RSSI
}

public protocol BLEDataSourceProtocol {

//    func start()
//    func stop()
    func observe() -> AnyPublisher<[BeaconObservation], Never>
}

