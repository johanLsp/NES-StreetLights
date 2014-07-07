/*
*
*    PIR Sensor - GPIO
*
*/

#define SENSTHRESH 3
#define DELAYT 500
#define DIGITALPIN DIGITAL8


int sens_counter = 0;

void setup()
{
  // init USB
  USB.begin();
  
  // enable 5V for sensor
  PWR.setSensorPower(SENS_5V, SENS_ON);  
  
  // setting Digital 8 as a sensor input
  pinMode(DIGITALPIN,INPUT);
}

void loop()
{
  // get sensor value
  if( digitalRead(DIGITALPIN) )
  {
   sens_counter++; 
  }
  
  // only if SENSTHRESH times the sensor detected smthg. a valid detection has occured
  if( sens_counter >= SENSTHRESH )
  {
   USB.println("Detect!");
   sens_counter = 0;
  }
  
  // wait some time
  delay(DELAYT);
}

