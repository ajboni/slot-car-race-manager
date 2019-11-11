#include <Chrono.h>

// Instanciate a Chrono object.
Chrono raceTick; 
Chrono eventTick; 
Chrono countdownTick;
Chrono racerTick[5] = {};


// Pin Mapping (index 0 is not used)
const int racersPins[5] = {0,11,12,10,9};

// SENSOR STATUS (index 0 is unused)
bool racersSensors[5] = {0,0,0,0,0};
bool isAnyRacerSensorHIGH = 0;

///// === MESAGGES === /////

// Commands
const byte C_START_RACE =            B00010000;
const byte C_START_RACE_1 =          B00010001;
const byte C_START_RACE_2 =          B00010010;
const byte C_START_RACE_3 =          B00010011;
const byte C_START_RACE_4 =          B00010101;
const byte C_FALSE_START[5] =        { B00110000, B00110001, B00110010, B00110011, B00110101 };

const byte C_GET_RACE_TIME =         B11111100;
byte S_CURRENT_RACE_TIME[8] =     { B00000000, B00000000, B00000000, B00000000, B00000000, B00000000, B00000000, B00000000 };
const byte C_RESTART_RACE =          B11111110;



// COUNTDOWN COMMANDS  (0010 0000)
const byte C_COUNTDOWN =             B00100000;
const byte C_COUNTDOWN_1 =           B00100001;
const byte C_COUNTDOWN_2 =           B00100010;
const byte C_COUNTDOWN_3 =           B00100011;
const byte C_COUNTDOWN_4 =           B00100100;
const byte C_COUNTDOWN_GO =          B00100101;
int currentCountdown = 0;

// Status messages
const byte C_GET_STATUS =           B11111111;
const byte C_STATUS_IDLE =          B11110000;
const byte C_STATUS_COUNTDOWN =     B11110001;
const byte C_STATUS_FALSE_START =   B11110010;
const byte C_STATUS_STARTED =       B11110011;
const byte C_STATUS_FINISHED =      B11110100;
  


// Debug
int buttonState = 0;         // variable for reading the pushbutton status
int ledState = 0;         // variable for reading the pushbutton status

// Race Setup
enum RaceState {
  _IDLE = B11110000,
  COUNTDOWN = C_STATUS_COUNTDOWN,
  FALSE_START = C_STATUS_FALSE_START,
  STARTED = C_STATUS_STARTED,
  FINISHED = C_STATUS_FINISHED
};

struct ServerMessages {
  bool startRace;
  bool restarRace;
};

RaceState raceState = _IDLE;

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
  pinMode(racersPins[1], INPUT);
  pinMode(racersPins[2], INPUT);
  pinMode(racersPins[3], INPUT);
  pinMode(racersPins[4], INPUT);
  
  Serial.begin(115200);
  raceTick.stop();
  countdownTick.stop();
}


void loop() {
  // Check state Machine
  stateMachineRun();
  
  // Minimum tick
   delay(10);
}  

void stateMachineRun() {
  serverCommand = Serial.read();
  
  // Quick response to status query
  if(serverCommand == C_GET_STATUS) {
    Serial.write(raceState);
  }

  // Restart State Machine
  if(serverCommand == C_RESTART_RACE) {
    restartRace();
  }

  // Quick response to Race Time
   if(serverCommand == C_GET_RACE_TIME) {
    getRaceTime();
  }

  // Check and update sensors Status
  checkSensors();

  // For debug only
  if(isAnyRacerSensorHIGH) {
    digitalWrite(LED_BUILTIN, HIGH);
  } else { 
    digitalWrite(LED_BUILTIN, LOW);
  }

  switch (raceState)
  {
  case _IDLE:
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
    countdownTick.restart();
    setState(COUNTDOWN);
    Serial.write(raceState);
    
  }
} 

/* Restart race, stop clocks and set status as idle */
void restartRace() {
    raceTick.stop();
    countdownTick.stop();
    setState(_IDLE);
    Serial.write(raceState);
}

void startRace() {
     Serial.write(C_COUNTDOWN_GO);
     setState(STARTED);     
     Serial.write(raceState);
     countdownTick.stop();
     raceTick.restart();

}

void getRaceTime() {
    Serial.write(C_GET_RACE_TIME);
    unsigned long el = raceTick.elapsed();
    
    S_CURRENT_RACE_TIME[0] = 0;
    S_CURRENT_RACE_TIME[1] = 0;
    S_CURRENT_RACE_TIME[2] = 0;
    S_CURRENT_RACE_TIME[3] = 0;
    S_CURRENT_RACE_TIME[7] = el & 0xFF; // 0x78
    S_CURRENT_RACE_TIME[6] = (el >> 8) & 0xFF; // 0x56
    S_CURRENT_RACE_TIME[5] = (el >> 16) & 0xFF; // 0x34
    S_CURRENT_RACE_TIME[4] = (el >> 24) & 0xFF; // 0x12
    
   
    Serial.write(S_CURRENT_RACE_TIME,8);
}

/* Run the timer and check for false starts. */
void countdown() {  

  /* If we reach the 5 seconds countdown advance the state machine */
  if(countdownTick.hasPassed(5000)) {
    startRace();
    currentCountdown = 0;
  }

  /* If we have any car doing a false start, notify it, and advance state machine until restart */
  if(isAnyRacerSensorHIGH > 0) {
       Serial.write(C_FALSE_START[isAnyRacerSensorHIGH]);
       setState(FALSE_START);
       countdownTick.restart();
       currentCountdown = 0;
       Serial.write(raceState);
  }
  
  /* Do the countdown */
  if (countdownTick.hasPassed(1000) && currentCountdown < 1) {
    currentCountdown = 1;
    Serial.write(C_COUNTDOWN_1);
  } else if (countdownTick.hasPassed(2000)  && currentCountdown < 2)  {
    currentCountdown = 2;
    Serial.write(C_COUNTDOWN_2);
  } else if (countdownTick.hasPassed(3000)  && currentCountdown < 3)  {
    currentCountdown = 3;
    Serial.write(C_COUNTDOWN_3);
  } else if (countdownTick.hasPassed(4000)  && currentCountdown < 4)  {
    currentCountdown = 4;
    Serial.write(C_COUNTDOWN_4);
  }
  
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
void setState(RaceState state) {
  raceState = state;
}

int checkFalseStart() {  
  return 0;
}

void checkSensors() {
    isAnyRacerSensorHIGH = 0;
    for (int i = 1; i <= totalRacers; i++) {
      racersSensors[i] = digitalRead(racersPins[i]);
      if(racersSensors[i] == HIGH) { isAnyRacerSensorHIGH = i; }
    }
}

/* Check for a server command for START RACE, and set the total racers accordingly*/
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
