import Combine
import Foundation

public typealias Distance = Float

public protocol EstimoteDataSourceProtocol {

    func observe() -> AnyPublisher<(UUID, Distance), Never>
}

