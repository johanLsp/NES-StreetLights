/*
*
*	Waspmote Sensor node final
*
*/

// configuration
#define SENSTHRESH 3            // Threshold for detecting
#define DELAYT 200              // Delay after polling pin
#define DIGITALPIN DIGITAL1     // Input Pin definition


// global variables
 int sens_counter = 0;          // sensor detection counter
 packetXBee *paq_sent;          // packet object
 int8_t state = 0;
 long previous = 0;
 char *data = "TEST";
 uint8_t PANID[2] = {0x12,0x34};
 char *KEY = "WaspmoteKey";
 

void setup()
{
  // init USB
  USB.begin();
  
  // enable 5V for sensor
  PWR.setSensorPower(SENS_5V, SENS_ON);  
  
  // setting digital pin as a sensor input
  pinMode(DIGITALPIN,INPUT);
  
  // init XBee
  xbee868.init(XBEE_868,FREQ868M,NORMAL);
  
  // power XBee
  xbee868.ON();
  
  // PANID : PANID=0x1234
  xbee868.setPAN(PANID);
  
  if( !xbee868.error_AT )
  {
    XBee.println("PANID set without Error!");
  }
  else
  {
    XBee.println("Error changing PANID");
  }
  
  // activate security : KEY="WaspmoteKey"
  xbee868.encryptionMode(1);
  
  if( !xbee868.error_AT )
  {
    XBee.println("Security activated");
  }
  else
  {
   XBee.println("Error activating security");
  }

  xbee868.setLinkKey(KEY);
  
  if( !xbee868.error_AT )
  {
    XBee.println("Key set without Error");
  }
  else
  {
    XBee.println("Error setting Key");
  }

  // store values
  xbee868.writeValues();
  
  if( !xbee868.error_AT )
  {
   XBee.println("Changes stored without Error");
  }
  else
  {
   XBee.println("Error storing values");
  }
}


// infinite loop - main program
void loop()
{
  // get sensor value
  if( digitalRead(DIGITALPIN) )
  {
   sens_counter++; 
  }
  
 // only if threshold is passed send a message 
 if( sens_counter > SENSTHRESH )
 {
  sens_counter = 0;
  
  // take this part into setup?
  
  // parameters to send
  paq_sent = (packetXBee*) calloc(1,sizeof(packetXBee)); 
  paq_sent->mode = UNICAST;
  paq_sent->MY_known = 0;
  paq_sent->packetID = 0x52;
  paq_sent->opt = 0;
  xbee868.hops = 0;
  xbee868.setOriginParams(paq_sent, "5678", MY_TYPE);
  xbee868.setDestinationParams(paq_sent, "0013A20040674869", data, MAC_TYPE, DATA_ABSOLUTE);
  
  // send data
  xbee868.sendXBee(paq_sent);
           
  if( !xbee868.error_TX )
  {
    XBee.print("Packet sent");
  }

  // release and reset packet
  free(paq_sent);
  paq_sent = NULL;

 }
 
 // delay getting new sensor value
 delay(DELAYT);
}
