
// Pin Mapping
const int buttonPin = 2;     // the number of the pushbutton pin
const int racer1Pin = 1;
const int racer2Pin = 2;
const int racer3Pin = 3;
const int racer4Pin = 4;

// Debug
int buttonState = 0;         // variable for reading the pushbutton status
int ledState = 0;         // variable for reading the pushbutton status

// Race Setup
enum RaceStatus {
  idle,
  started,
  finished
};

RaceStatus raceStatus = idle;
int totalLaps = 0;
unsigned long raceStartTime = 0;
unsigned long raceFinishTime = 0;
unsigned long[] racer1Laps;
unsigned long[] racer2Laps;
unsigned long[] racer3Laps;
unsigned long[] racer4Laps;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(buttonPin, INPUT);
  pinMode(racer1Pin, INPUT);
  pinMode(racer2Pin, INPUT);
  pinMode(racer3Pin, INPUT);
  pinMode(racer4Pin, INPUT);
  
  Serial.begin(19200);
}


void loop() {
  // Idle
  
  
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);
  ledState = digitalRead(LED_BUILTIN);

  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (buttonState == HIGH && ledState == LOW) {
    // turn LED on:
    digitalWrite(LED_BUILTIN, HIGH);
    Serial.write("LED");
    delay(1000);
    digitalWrite(LED_BUILTIN, LOW);
  }


}
