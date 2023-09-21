import Combine
import CoreBluetooth
import Foundation

public class BLEDataSource: NSObject {

    private var centralManager: CBCentralManager!
    private var peripherals: [CBPeripheral] = []
    private var rssis: [UUID: NSNumber] = [:]
    private var subject = CurrentValueSubject<[BeaconObservation], Never>([])
    private var cancellables: [AnyCancellable] = []

    public private(set) var isActive: Bool = false

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
                guard let self, self.isActive else { return }
                let currentTimeString = self.dateFormatter.string(from: Date())
                if !self.peripherals.isEmpty {
                    self.pollRssis()
                    print("\(currentTimeString) Scheduled RSSI poll.")
                }
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
        case .poweredOn where isActive:
            centralManager.scanForPeripherals(withServices: nil, options: nil)
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

        guard (peripheral.name ?? "").hasPrefix("Echo-BLE-00") else {
            // we're not interested in anything else
            return
        }

        func printMe() {
            let currentTimeString = dateFormatter.string(from: Date())
            let prefix = !isKnown ? "Discovered: " : "Updated:    "
            print("\(currentTimeString) \(prefix) \(peripheral.name ?? "Unknown Device") - \(peripheral.identifier) \(RSSI)")
        }

        printMe()

        // always store the RSSI
        rssis[peripheral.identifier] = RSSI

        if !isKnown {
            peripherals.append(peripheral)
            peripheral.delegate = self
            central.connect(peripheral)
            broadcast()
        } else {
        }
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "<?>").")
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        peripherals.removeAll { $0 == peripheral }
        print("Disconnected from \(peripheral.name ?? "<?>") (\(error?.localizedDescription ?? "")).")
        broadcast()
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

    public func activate() {
        guard !isActive else { return print("BLEDS already active.") }
        isActive = true
//        centralManager.scanForPeripherals(withServices: [.deviceInformationService], options: nil)
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    public func deactivate() {
        guard isActive else { return print("BLEDS not active.") }
        isActive = false
        centralManager.stopScan()
    }

    public func observe() -> AnyPublisher<[BeaconObservation], Never> {
        subject
            .eraseToAnyPublisher()
    }
}
