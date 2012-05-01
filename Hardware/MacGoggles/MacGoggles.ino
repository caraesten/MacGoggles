/*
  MacGoggles, by Esten Hurtle
  
  See circuit diagram included for instructions on wiring this

*/
int bPin = A1;
int breathOnPin = 5;
int breathTrigger = 4;
int breathState = 0;
int breathState2 = 0;
int highestReading = 0;
int readingFrames = 0;

void setup(){
  pinMode(breathOnPin, OUTPUT);
  pinMode(breathTrigger, INPUT);
  digitalWrite(breathOnPin, breathState);
  pinMode(bPin, INPUT);
  Serial.begin(9600);
  Serial.print("STARTED");
}

int measureBreath(int breathPin){
  return analogRead(breathPin);
}

void loop() {
  // Write to transistor to keep it on
  digitalWrite(breathOnPin, breathState);
  // If the breathalyzer is on
  if (breathState == 1){
    // If it's not actively reading, check button
    if (breathState2 == 0){
      breathState2 = digitalRead(breathTrigger);
    }
    // If it is actively reading, do reading logic
    if (breathState2 == 1){
      if (readingFrames == 0){
          // Initialize reading frames
          readingFrames = 15000;
      }
      // If there's more frames left to read
      if (readingFrames > 0){
        // if the current reading is higher than the existing highest, store it
        if (measureBreath(bPin) > highestReading){
          highestReading = measureBreath(bPin);
        }
        // decrement frames
        readingFrames -= 1;
      }
      // If it's done reading...
      if (readingFrames == 0){
        // Print the highest reading
        Serial.print("\nDLEVEL ");
        Serial.print(highestReading);
        highestReading = 0;
        breathState = 0;
        breathState2 = 0;
        highestReading = 0;
      }
    }
  }
  else {
    breathState = digitalRead(breathTrigger);
    if (breathState == 1){
      digitalWrite(breathOnPin, breathState);      
      Serial.print("\nBREON");
      delay(30000);
      Serial.print("\nBREWRM");
    }
  }
}
