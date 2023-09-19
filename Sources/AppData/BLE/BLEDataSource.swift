import Combine
import CoreBluetooth
import Foundation

public class BLEDataSource: NSObject {

    private var centralManager: CBCentralManager!
    private var peripherals: [CBPeripheral] = []
    private var rssis: [UUID: NSNumber] = [:]
    private var subject = CurrentValueSubject<[BeaconObservation], Never>([])

    private var cancellables: [AnyCancellable] = []

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }()

    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)

        Timer.publish(every: 5, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                let currentTimeString = self.dateFormatter.string(from: Date())
                print("\(currentTimeString) Scheduling RSSI poll…")
                self.pollRssis()
            }
            .store(in: &cancellables)
    }

    private func broadcast() {
        let observations: [BeaconObservation] = peripherals.compactMap {
            guard let rssi = rssis[$0.identifier] else { return nil }
            return BeaconObservation(
                uuid: $0.identifier,
                name: $0.name ?? "<?>",
                rssi: rssi.floatValue
            )
        }

        subject.send(observations)
    }

    private func pollRssis() {
        for peripheral in peripherals where peripheral.state == .connected {
            peripheral.readRSSI()
        }
    }
}

extension BLEDataSource: CBCentralManagerDelegate {

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {

        switch central.state {
        case .poweredOn:
            print("BLEDataSource has powered central. Scanning…")
            //central.scanForPeripherals(withServices: nil, options: nil)
        default:
            print(central.state)
        }
    }

    public func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        let isKnown = peripherals.contains(peripheral)

        func printMe() {
            let currentTimeString = dateFormatter.string(from: Date())
            let prefix = !isKnown ? "Discovered: " : "Updated:    "
            print("\(currentTimeString) \(prefix) \(peripheral.name ?? "Unknown Device") - \(peripheral.identifier) \(RSSI)")
        }

        // let blacklist = ["Apple", "iPad", "iPhone", "Ringen", "Edwin", "Bagage", "Rommel", "Studeerkamer"]

        // always store the RSSI
        rssis[peripheral.identifier] = RSSI

        if !isKnown {
            peripherals.append(peripheral)
            peripheral.delegate = self
            central.connect(peripheral)
            broadcast()
        }
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "<?>").")
    }
}

extension BLEDataSource: CBPeripheralDelegate {

    public func peripheral(
        _ peripheral: CBPeripheral,
        didReadRSSI RSSI: NSNumber,
        error: Error?
    ) {
        rssis[peripheral.identifier] = RSSI
        broadcast()
    }
}

extension BLEDataSource: BLEDataSourceProtocol {

    public func observe() -> AnyPublisher<[BeaconObservation], Never> {
        subject
            .eraseToAnyPublisher()
    }
}
