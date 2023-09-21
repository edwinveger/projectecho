import AppDomain
import Combine
import Foundation

public typealias RSSI = Float

public struct BeaconObservation: Equatable {
    let uuid: UUID
    let name: String
    let rssi: RSSI
}

public protocol BLEDataSourceProtocol: Activatable {

    func observe() -> AnyPublisher<[BeaconObservation], Never>
}

