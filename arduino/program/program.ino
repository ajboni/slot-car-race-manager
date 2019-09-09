

#define echo 10 //define la salida por donde se recibe el rebote como 10
#define trigger 11  //define la salida por donde se manda el pulso como 9
int distance;  //crea la variable "distancia"
float returnTime;  //crea la variable tiempo (como float)
float detectionDistance = 10;
int laps[100];
int currentLap = 0;
unsigned long startTime = millis();
unsigned long raceStartTinme = millis();
unsigned long raceFinishTime = millis();


// the setup function runs once when you press reset or power the board
void setup() {
 
  // initialize digital pin LED_BUILTIN as an output.
  Serial.begin(9600); 
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(echo, INPUT); 
  pinMode(trigger, OUTPUT); 
  
}

// the loop function runs over and over again forever
void loop() {

  digitalWrite(trigger,LOW); //Por cuestión de estabilización del sensor
  delayMicroseconds(5);
  digitalWrite(trigger, HIGH); //envío del pulso ultrasónico
  delayMicroseconds(10);
  returnTime = pulseIn(echo, HIGH);  //funcion para medir el tiempo y guardarla en la variable "tiempo"
  distance = 0.01715*returnTime; //fórmula para calcular la distancia
   
  /*Monitorización en centímetros por el monitor serial*/
  if(distance < detectionDistance) {
    Serial.print("Vuelta: ");
    Serial.print(currentLap);
    Serial.print(" => ");        
    Serial.println(TimeToString(millis() - startTime)); 
    currentLap++;
    startTime = millis();
    delay(100);
  }
  delay(20);
  
  if(currentLap >= 10) {
      
  }

  
}


// t is time in seconds = millis()/1000;
char * TimeToString(unsigned long t)
{
 static char str[12];
 long h = t / 3600;
 t = t % 3600;
 int m = t / 60;
 int s = t % 60;
 sprintf(str, "%04ld:%02d:%02d", h, m, s);
 return str;
}
