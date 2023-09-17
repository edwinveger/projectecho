import Foundation
import CoreBluetooth

class BLEDelegate: NSObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    var peripherals: [CBPeripheral] = []

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }()

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth not available.")
        }
    }

    func centralManager(
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

        if !isKnown {
            peripherals.append(peripheral)
            printMe()
        } else {
            if peripheral.name == "Ringen" {
                printMe()
            }
        }
    }
}

let delegate = BLEDelegate()

// Keep the script running
RunLoop.main.run()

