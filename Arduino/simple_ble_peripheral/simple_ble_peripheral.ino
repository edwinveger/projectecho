#include <ArduinoBLE.h>

BLEService disService("180A");
BLEStringCharacteristic deviceNameCharacteristic("2A00", BLERead, 50);

const int outputPin = 2; // Pin D2 on Arduino Nano

// BLE == BLELocalDevice

void setup() {
  Serial.begin(9600);
  Serial.println("Booting…");

  pinMode(outputPin, OUTPUT);

  if (!BLE.begin()) {
    Serial.println("Starting BLE module failed. Retrying…");
    while (1);
  }

  Serial.println("BLE started.");

  const char *name = "Echo-BLE-003";

  BLE.setLocalName(name);
  BLE.setDeviceName(name);

  //   // Add the Device Information Service (for optional client filtering)
  //   BLE.addService(disService);

  //  // Set the initial value for the Device Name Characteristic
  //   deviceNameCharacteristic.setValue("deviceName");

  //   // // Add the Device Name Characteristic to the DIS
  //   disService.addCharacteristic(deviceNameCharacteristic);

  BLE.advertise(); 
}

void loop() {
  if (BLE.central().connected()) { 
    digitalWrite(outputPin, HIGH);
  } else {
    digitalWrite(outputPin, LOW);
  }

  delay(500);
}
