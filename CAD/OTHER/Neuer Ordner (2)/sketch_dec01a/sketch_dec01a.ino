#include <SoftwareSerial.h>

SoftwareSerial BTserial(8,9); //RX, TX

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  BTserial.begin(9600);
  while(!Serial);
  Serial.println("AT something");
}

void loop() {
  // put your main code here, to run repeatedly:
  if(BTserial.available())
    Serial.write(BTserial.read());

  if(Serial.available())
    BTserial.write(Serial.read());
}
