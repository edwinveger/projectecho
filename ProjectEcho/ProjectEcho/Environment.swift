import AppData
import AppDomain

struct Environment {

    static let shared = Self()

    let estimoteRepository: EstimoteRepository
    let bleRepository: BLERepository

    init() {
        let estimoteDataSource = EstimoteDataSource()
        let bleDataSource = BLEDataSource()
        estimoteRepository = EstimoteRepository(dataSource: estimoteDataSource)
        bleRepository = BLERepository(dataSource: bleDataSource)

        print("Environment is ready.")
    }
}

