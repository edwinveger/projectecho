import AppData
import AppDomain

struct Environment {

    static let shared = Self()

    let estimoteRepository: EstimoteRepository
    let bleRepository: BLERepository

    init() {
        let estimoteDataSource = EstimoteDataSource()
        // estimoteDataSource.activate()
        estimoteRepository = EstimoteRepository(dataSource: estimoteDataSource)

        let bleDataSource = BLEDataSource()
        bleDataSource.activate()
        bleRepository = BLERepository(dataSource: bleDataSource)

        print("Environment is ready.")
    }
}

