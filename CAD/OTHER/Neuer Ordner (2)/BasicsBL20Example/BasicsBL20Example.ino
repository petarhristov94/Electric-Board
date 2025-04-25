#include <SoftwareSerial.h>
SoftwareSerial mySerial(8, 9); // RX, TX
char w;
boolean NL = true;
boolean led = false;

void setup() {
  Serial.begin(9600);
  mySerial.begin(9600);
  pinMode(13, OUTPUT);
}

void loop() {
  if (mySerial.available()) {
    w = mySerial.read();
    Serial.write(w);
    if (w == '1') {
      led = !led;
      digitalWrite(13, led);
      Serial.println();
      Serial.write("LED State Changed");
      mySerial.write("LED State Changed");
    }
  }

  if (Serial.available()) {
    w = Serial.read();
    mySerial.write(w);

    if (NL) {
      Serial.print(">");
      NL = false;
    }
    Serial.write(w);
    if (w == 10) {
      NL = true;
    }
  }
}
