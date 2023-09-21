#include <ArduinoBLE.h>

BLEService disService("180A");
// BLEStringCharacteristic deviceNameCharacteristic("2A00", BLERead);

void setup() {
  if (!BLE.begin()) {
    while (1);
  }

  // BLE.setLocalName("Echo-BLE-001");
  // BLE.setLocalName("Echo-BLE-002");
  BLE.setLocalName("Echo-BLE-003");

  // Add the Device Information Service (for optional client filtering)
  BLE.addService(disService);

  // // Add the Device Name Characteristic to the DIS
  // disService.addCharacteristic(deviceNameCharacteristic);

  BLE.advertise();
}

void loop() {
}
