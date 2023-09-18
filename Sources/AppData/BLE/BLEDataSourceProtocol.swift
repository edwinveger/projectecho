import Combine
import Foundation

public typealias Confidence = Float
public typealias BeaconObservation = (UUID, Confidence)

public protocol BLEDataSourceProtocol {

    func observe() -> AnyPublisher<[BeaconObservation], Never>
}

