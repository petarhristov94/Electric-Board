#include <nRF24L01.h>
#include <printf.h>
#include <RF24.h>
#include <RF24_config.h>

#include <SPI.h>
#include <VescUart.h>

//#define DEBUG

struct vescValues {
  float ampHours;
  float inpVoltage;
  long rpm;
  long tachometerAbs;
};

RF24 radio(9, 10);
const uint64_t pipe = 0xE8E8FFFF61LL; //0xE8E8FFFF61LL

bool chip;
bool recievedData = false;
uint32_t lastTimeReceived = 0;

int motorSpeed = 127;
int timeoutMax = 500;
int speedPin = 5;

#define STATUS_LED 7

struct bldcMeasure measuredValues;

struct vescValues data;
unsigned long lastDataCheck;

void setup() {
  Serial.begin(115200);

  radio.begin();
  radio.enableAckPayload();
  radio.enableDynamicPayloads();
  radio.openReadingPipe(1, pipe);
  radio.startListening();

  pinMode(speedPin, OUTPUT);
  analogWrite(speedPin, motorSpeed);
  pinMode(STATUS_LED, OUTPUT);

  #ifdef DEBUG
    printf_begin();
    radio.printDetails();
    if (radio.isChipConnected())
    Serial.println("Chip is connected");
  else
    Serial.println("Chip is NOT connected");
  #endif
}

void loop() {

  getVescData();

  // If transmission is available
  if (radio.available()) {
    // The next time a transmission is received on pipe, the data in gotByte will be sent back in the acknowledgement (this could later be changed to data from VESC!)
    radio.writeAckPayload(pipe, &data, sizeof(data));

    // Read the actual message
    radio.read(&motorSpeed, sizeof(motorSpeed));
    recievedData = true;
  }

  if (recievedData == true) {
    // A speed is received from the transmitter (remote).
    lastTimeReceived = millis();
    recievedData = false;
    // Write the PWM signal to the ESC (0-255).
    analogWrite(speedPin, motorSpeed);
    digitalWrite(STATUS_LED, HIGH);
  }
  else if ((millis() - lastTimeReceived) > timeoutMax) {
    // No speed is received within the timeout limit.
    motorSpeed = 127;
    analogWrite(speedPin, motorSpeed);
  }
  else {
    // no data received, turn off LED
    digitalWrite(STATUS_LED, LOW);
  }
  Serial.println(motorSpeed);
}

void getVescData() {

  if (millis() - lastDataCheck >= 250) {

    lastDataCheck = millis();

    // Only transmit what we need
    if (VescUartGetValue(measuredValues)) {
      data.ampHours = measuredValues.ampHours;
      data.inpVoltage = measuredValues.inpVoltage;
      data.rpm = measuredValues.rpm;
      data.tachometerAbs = measuredValues.tachometerAbs;
    } else {
      data.ampHours = 0.0;
      data.inpVoltage = 0.0;
      data.rpm = 0;
      data.tachometerAbs = 0;
    }
  }
}
