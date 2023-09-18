import Combine
import CoreBluetooth
import Foundation

public class BLEDataSource: NSObject {

    private var centralManager: CBCentralManager!
    private var peripherals: [CBPeripheral] = []

    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

extension BLEDataSource: CBCentralManagerDelegate {

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {

        switch central.state {
        case .poweredOn:
            print("BLEDataSource has powered central.")
        default:
            print(central.state)
        }
    }
}

extension BLEDataSource: BLEDataSourceProtocol {

    public func observe() -> AnyPublisher<[BeaconObservation], Never> {
        Empty()
            .eraseToAnyPublisher()
    }
}
