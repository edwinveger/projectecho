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

        let blacklist = ["Apple", "iPad", "iPhone", "Ringen", "Edwin", "Bagage", "Rommel", "Studeerkamer"]


        if !isKnown {
            peripherals.append(peripheral)

            guard
                !blacklist.contains(where: { (peripheral.name ?? "").hasPrefix($0) })
            else {
                print("Skipping \(peripheral.name ?? "").")
                return
            }

            printMe()
            central.connect(peripheral)
            peripheral.delegate = self
        } else {
            // if peripheral.name == "Ringen" {
            //     printMe()
            // }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("\(peripheral.name ?? "Unknown Device") connected. Discovering…")
        peripheral.discoverServices(nil)
    }
}

extension BLEDelegate: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else { return }

        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(nil, for: service)
        }

        // printServicesAndCharacteristics(for: peripheral)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else { return }

        //centralManager.
        printServicesAndCharacteristics(for: peripheral)

        if peripheral.name == "raspberrypi", let c = peripheral.services?.first?.characteristics?.first {
            peripheral.readValue(for: c)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // characteristic.value
    }
}

func printServicesAndCharacteristics(for peripheral: CBPeripheral) {
    if let services = peripheral.services {
        print("==================================================================")
        print("\(peripheral.name ?? "Unknown Device") has the following services:")
        for service in services {
            print("Service: \(service.uuid.uuidString)")

            for characteristic in service.characteristics ?? [] {
                print("  Characteristic: \(characteristic.uuid.uuidString)")
            }
        }
        print("==================================================================")
    } else {
        // print("No services.")
    }
}

let delegate = BLEDelegate()

// Keep the script running
RunLoop.main.run()

