#include <Chrono.h>

// Instanciate a Chrono object.
Chrono raceTick; 
Chrono eventTick; 
Chrono racer1Tick; 
Chrono racer2Tick;
Chrono racer3Tick;
Chrono racer4Tick;

// Pin Mapping
const int racer1Pin = 1;
const int racer2Pin = 2;
const int racer3Pin = 3;
const int racer4Pin = 4;

// Messages 
const byte C_START_RACE = B00010000;
const byte C_FALSE_START = B00100000;


// Debug
int buttonState = 0;         // variable for reading the pushbutton status
int ledState = 0;         // variable for reading the pushbutton status

// Race Setup
enum RaceState {
  IDLE,
  COUNTDOWN,
  FALSE_START,
  STARTED,
  FINISHED
};

struct ServerMessages {
  bool startRace;
  bool restarRace;
};

RaceState raceState = IDLE;


int totalLaps = 0;
int totalRacers = 2;
int serverCommand = -1;
unsigned long raceStartTime = 0;
unsigned long raceFinishTime = 0;
// Antipassback for lap, to avoid false positives, each lap has to have at least this quantity of milli seconds passed.
unsigned long lapAntipassback = 5000;
unsigned long r = 0;
//unsigned long[] racer1Laps;
//unsigned long[] racer2Laps;
//unsigned long[] racer3Laps;
//unsigned long[] racer4Laps;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(racer1Pin, INPUT);
  pinMode(racer2Pin, INPUT);
  pinMode(racer3Pin, INPUT);
  pinMode(racer4Pin, INPUT);
  
  Serial.begin(115200);
}

void loop() {
  // Check state Machine
  stateMachineRun();
  
  // Minimum tick
  // delay(1);
}  

void stateMachineRun() {
  serverCommand =  Serial.read();
  switch (raceState)
  {
  case IDLE:
    idle();
    break;
  case COUNTDOWN: 
    countdown();
    break;
  case FALSE_START:
    falseStart();
    break;
  case STARTED:
    started();
    break;
  case FINISHED:
    finished();
    break;
  default:
    break;
  }
}

/* Check for race start message and initialize countdown. */
void idle() {  

  // Start Race 
  if(checkStartRace(serverCommand)) {    
    setSate(COUNTDOWN);
  }
} 

/* Run the timer and check for false starts. */
void countdown() {
  
}

/* Notify Server about false start and wait for new command to re call the countdown. */
void falseStart() {

}

/** Main Race Loop */
void started() {

}

/* Race has finished succesfully. Notify server, and fallback to idle after some time. */
void finished() {
  
}

/* Set a race state  */
void setSate(RaceState state) {
  raceState = state;
}

int checkFalseStart() {  
  return 0;
}

bool checkStartRace(byte cmd) {

  byte command = stripCommand(cmd);
  byte value = stripValue(cmd);

  if(command == C_START_RACE) {
      Serial.write(command);
      Serial.write(value);
      totalRacers = value;
      return true;
  }
  else {
    return false;
  }
  
}

byte stripValue (byte b) {
  b = b << 4;
  b = b >> 4;
  return b;
}

byte stripCommand (byte b) {
   // Shift value bytes into non existence
   b = b >> 4;
   b = b << 4;
   return b;
}
