import Combine
import Foundation
//import EstimoteProximitySDK
import EstimoteUWB

public class EstimoteDataSource {

    private var uwbManager: EstimoteUWBManager!
    private let subject = CurrentValueSubject<[EstimoteObservation], Never>([])

    public private(set) var isActive: Bool = false

    public init() {
        uwbManager = EstimoteUWBManager(
            delegate: self,
            options: EstimoteUWBOptions(shouldHandleConnectivity: true, isCameraAssisted: false)
        )
    }
}

extension EstimoteDataSource: EstimoteUWBManagerDelegate {

    public func didUpdatePosition(for device: EstimoteUWBDevice) {
        var observations = subject.value
        observations.removeAll { $0.id == device.id }

        let newObservation = EstimoteObservation(id: device.id, distance: device.distance)
        observations.append(newObservation)

        subject.send(observations)
    }

    public func didDiscover(device: UWBIdentifiable, with rssi: NSNumber, from manager: EstimoteUWBManager) {
        print("[Estimote] Discovered Device: \(device.publicIdentifier) rssi: \(rssi)")
        //manager.connect(to: device)
    }

    public func didConnect(to device: UWBIdentifiable) {
        print("[Estimote] Connected to: \(device.publicIdentifier)")
    }

    public func didFailToConnect(to device: UWBIdentifiable, error: (Error)?) {
        print("[Estimote] Failed to connect to: \(device.publicIdentifier)")
    }
}

extension EstimoteDataSource: EstimoteDataSourceProtocol {

    public func activate() {
        guard !isActive else { return print("EstimoteDS already active.") }
        isActive = true
        uwbManager.startScanning()
    }

    public func deactivate() {
        guard isActive else { return print("EstimoteDS not active.") }
        isActive = false
        uwbManager.stopScanning()
    }

    public func observe() -> AnyPublisher<[EstimoteObservation], Never> {
        subject
            // .print("[Estimote DS]")
            .eraseToAnyPublisher()
    }
}
