const int button1Pin = 2;  // Button 1 pin
const int button2Pin = 4;  // Button 2 pin
const int potentiometerPin = A0; // Potentiometer pin
const int speakerPin = 8;  // Speaker pin

//const unsigned long bitDuration = 1000; // 0.001 seconds
const unsigned long bitDuration = 400000; // 0.1 seconds

// Define the 4-bit binary value to be modulated
const byte dataToModulate = 0b1010; // Change this to your desired 4-bit binary value

bool soundEnabled = false;  // Global flag to enable/disable sound
int volume = 0;           // Variable to store volume
int frequencyIndex = 1;   // Index to select frequencies from the list
unsigned int frequencies[] = {220, 440, 880, 1760, 17600, 22000}; // List of frequencies

// Variables to store previous button states
bool prevButton1State = LOW;
bool prevButton2State = LOW;

void setup() {
  pinMode(button1Pin, INPUT);
  pinMode(button2Pin, INPUT);

  Serial.begin(9600);
}

void loop() {
  handleButton1();
  handleButton2();

  // Read the potentiometer value and map it to volume
  //int potValue = analogRead(potentiometerPin);
  // Serial.println(potValue);
  //volume = map(potValue, 0, 1023, 0, 255);

  // Generate and play sound if sound is enabled
  if (soundEnabled) {
    playSound();
  } else {
    noTone(speakerPin); // Turn off the sound if disabled
  }
}

void handleButton1() { 
  // Read the state of Button 1
  bool button1State = digitalRead(button1Pin);

  // Toggle sound output if Button 1 is pressed
  if (button1State == HIGH && button1State != prevButton1State) {
    soundEnabled = !soundEnabled;
    Serial.print("SoundEnabled:" );
    Serial.println(soundEnabled);
  }
  prevButton1State = button1State;
}

void handleButton2() {
   // Read the state of Button 2
  bool button2State = digitalRead(button2Pin);

  // Change frequency if Button 2 is pressed
  if (button2State == HIGH && button2State != prevButton2State) {
    frequencyIndex = (frequencyIndex + 1) % (sizeof(frequencies) / sizeof(frequencies[0]));
    Serial.print("New frequency:" );
    Serial.println(frequencies[frequencyIndex]);
  }
  prevButton2State = button2State;
}

void playSound() { 
  // Modulate and emit the signal
  for (int i = 0; i < 4; i++) {
    int bit = (dataToModulate >> i) & 0x01; // Extract each bit from the 4-bit data

    // Modulate and emit the bit
    modulateAndEmit(bit);
  }

  // Delay before transmitting the next set of bits
  delay(1000); // Adjust as needed
}

unsigned int carrierFrequency() { 
  return frequencies[frequencyIndex];
}

void modulateAndEmit(int bit) {
  unsigned long startTime = micros();

  while (micros() - startTime < bitDuration) {
    if (bit == 1) {
      tone(speakerPin, carrierFrequency()); // Transmit the carrier frequency for a 1 bit
    } else {
      noTone(speakerPin); // Turn off the carrier signal for a 0 bit
    }
  }

  noTone(speakerPin);
}
