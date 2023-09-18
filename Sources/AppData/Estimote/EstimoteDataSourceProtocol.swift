import Combine
import Foundation

public struct EstimoteObservation: Equatable {
    let id: String
    let distance: Float
}

public protocol EstimoteDataSourceProtocol {

    func observe() -> AnyPublisher<[EstimoteObservation], Never>
}
