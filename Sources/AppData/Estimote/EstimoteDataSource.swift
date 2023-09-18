import Combine
import Foundation

public class EstimoteDataSource {

    public init() { }
}

extension EstimoteDataSource: EstimoteDataSourceProtocol {

    public func observe() -> AnyPublisher<(UUID, Distance), Never> {
        Empty()
            .eraseToAnyPublisher()
    }
}
