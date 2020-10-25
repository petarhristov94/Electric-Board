//#include <SoftwareSerial.h>

//SoftwareSerial BTserial(8, 9); //RX, TX

int ledPin = 13;
int state = 0;
int flag = 0;

void setup() {
  digitalWrite(ledPin, LOW);
  
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
  //  BTserial.begin(9600);
  Serial.println("BTserial started at 9600");
}

void loop() {

  // Read from the Serial Monitor and send to the Bluetooth module
  if (Serial.available()) {
    state = Serial.read();
    flag = 0;
    //BTserial.write(Serial.read());
  }

  /*// Read from the Bluetooth module and send to the Arduino Serial Monitor
  if (BTserial.available()) {
    //state = Serial.read();
    //flag = 0;
    Serial.write(BTserial.read());
    state = Serial.read();
  }*/

  if (state == '0') {
    digitalWrite(ledPin, LOW);
    if (flag == 0) {
      Serial.println("LED: off");
      flag = 1;
    }
  }

  else if (state == '1') {
    digitalWrite(ledPin, HIGH);
    if (flag == 0) {
      Serial.println("LED: on");
      flag = 1;
    }
  }
}
