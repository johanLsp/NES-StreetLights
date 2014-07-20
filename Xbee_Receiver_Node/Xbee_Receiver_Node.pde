/*
*
* Waspmote Xbee Receiver final
*
*/





/**
 *  Configuration :
 *
 *  Sections :        S1          S2
 *              |-----------|------------|
 *  Nodes :     N1          N2           N3
 */



/**  LEDs control assembler definition
 *
 *  Timings for LED control communication are very tight (change pin state every 3-5 clock cycle @8MHz)
 *  API pin write is too slow
 *  We write directly to pin port with following asm macros to fit timing constraints
 *
 */


 #define NOP __asm__("nop\n\t")
 
 #define HI __asm__("ldi r30, 0x30;\n\t out 0x08, r30\n\t")
 #define LO __asm__("ldi r30, 0x00;\n\t out 0x08, r30\n\t")
 
 
 /**
  *  See WS2812 (LED) doc for coding & timing explanation
  */
 #define B_0   HI; NOP; LO; NOP; NOP; NOP; NOP; NOP
 #define B_1   HI; NOP; NOP; NOP; NOP; LO; NOP; NOP
 

 #define BYTE_0   B_0; B_0; B_0; B_0; B_0; B_0; B_0; B_0 // 0b00000000
 #define BYTE_1   B_0; B_0; B_0; B_1; B_1; B_1; B_1; B_1 // 0b00011111 Not fully lit up to avoid consuming too much
  

  
 #define BLACK   BYTE_0; BYTE_0; BYTE_0
 #define WHITE   BYTE_1; BYTE_1; BYTE_1
 #define GREEN   BYTE_1; BYTE_0; BYTE_0
 #define RED     BYTE_0; BYTE_1; BYTE_0
 #define BLUE    BYTE_0; BYTE_0; BYTE_1
 
 
 // configuration
 #define SENSTHRESH 10 // Threshold for detecting
 #define DELAYT 200 // Delay after polling pin
 #define DIGITALPIN DIGITAL1 // Input Pin definition

 
 // global variables
 packetXBee *paq_sent;
 int8_t state = 0;
 long previous = 0;
 uint8_t destination[8];
 uint8_t i = 0;
 uint8_t PANID[2] = {0x12,0x34};
 char *KEY = "WaspmoteKey";
 long macAddr;
 int sens_counter;
 
 
 long timerS1, timerS2, timerN1, timerN2, timerN3, senseTime;  // Timer to keep track of sections / node activation
 boolean ledS1, ledS2;                                         // Sections states
 boolean detectN1, detectN2, detectN3;                         // Nodes states




void setup()
{  
  ledS1 = false;
  ledS2 = false;
  
  timerN1 = 0;
  timerN2 = 0;
  timerN3 = 0;
  timerS1 = 0;
  timerS2 = 0;
  senseTime = 0;
  
  sens_counter = 0;
 
 
 //  Led strip 1
  pinMode(DIGITAL7,OUTPUT);
  digitalWrite(DIGITAL7,LOW);

 //  Led strip 2
  pinMode(DIGITAL8,OUTPUT);
  digitalWrite(DIGITAL8,LOW);
  
  
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


// main program
void loop()
{

  if( XBee.available() )
  { 
    
    
    sens_counter = 0;
   // XBee.print("Receiving");
   // XBee.println("");
   xbee868.treatData();
   
   if( !xbee868.error_RX )
   {
     while( xbee868.pos > 0 ) // some message is available
     {
       
       // here check which node (MAC or PID?) send it detected something
       // and then activate the leds for that section
      int packetId = xbee868.packet_finished[xbee868.pos-1]->packetID;

      switch(packetId) {
       case 2 :
               
         XBee.print("N2 : detection");
      
         XBee.println("");
                  
          
          // Update nodes states : true = node detection occured in last 5s
          detectN1 = (millis() - timerN1) < 5000;
          detectN2 = (millis() - timerN2) < 5000;
          detectN3 = (millis() - timerN3) < 5000;
          
          
          
          if(!detectN2) {
            timerN2 = millis();
            
            // Object goes N1->N2 : light up S2
            if (detectN1 && !detectN3) {
             timerS2 = millis();
             
             // Object goes N3->N2 : light up S1
            } else if (!detectN1 && detectN3) {
             timerS1 = millis();
             
             // New object or multiple objects : light up S1 & S2
            } else {
              timerS1 = millis();
              timerS2 = millis();
            }
          
          }
    
          break;
        
        
        
        case 3 :
            
              XBee.print("N3 : detection");
              XBee.println("");
             
             //  Update node state         
             detectN3 = (millis() - timerN3) < 5000;
             
             
             if(!detectN3) {
               timerN3 = millis();
               
               // Object goes N3 -> N2 : light up S2               
              if ((millis() - timerN2) >= 5000) {
                timerS2 = millis();
              }
              
              // else : object goes N2-> N3 : do nothing
              
             }
          break;
              
       }
       
      
       // finish
       free( xbee868.packet_finished[xbee868.pos-1] );
       xbee868.packet_finished[xbee868.pos-1] = NULL;
       xbee868.pos--;
     }
   }
   

  } else {
    
    // If not receving packet, check sensor value
    // Reason : There seems to be a conflit between Xbee & getting sensor value
    
    if (millis() - senseTime > DELAYT) {
    
      if(millis() - senseTime > 3*DELAYT) {
       sens_counter = 0; 
      }
    
     senseTime = millis();
    
      if (digitalRead(DIGITALPIN)) {
        sens_counter++;
      }
      
    
      if (sens_counter > SENSTHRESH) {
              XBee.print("N1 : detection");
      XBee.println("");
      sens_counter = 0;
      
      
      detectN1 = (millis() - timerN1) < 5000;
      
      
      
      if(!detectN1) {
        timerN1 = millis();
        
        // Object goes N1 -> N2 : light up S1
        if ((millis() - timerN2) >= 5000) {
            timerS1 = millis();
        }
        
        // else : Object goes N2 -> N1 : do nothing
      }
        
      }
       
    
    
    
    
  }
  
  }
  
  
  
  // Light on / off the LED depending on current state
  
  
  // Section S1
  if(millis() - timerS1 >= 5000 && ledS1) {
    
    lightB(false, ledS2);
    XBee.print("S1 : Off");
    XBee.println("");
    ledS1 = false;
    
  } else if (millis() - timerS1 < 5000 && !ledS1) {

    lightB(true, ledS2);
    XBee.print("S1 : On");
    XBee.println("");
    ledS1 = true;
  }
  
  
  // Section S2
  if(millis() - timerS2 >= 5000 && ledS2) {

    lightB(ledS1, false);
    ledS2 = false;
    XBee.print("S2 : Off");
    XBee.println("");
    
  } else if (millis() - timerS2 < 5000 && !ledS2) {

    lightB(ledS1, true);
    XBee.print("S2 : On");
    XBee.println("");
    ledS2 = true;
  }
   
   
   
}






void lightB(boolean S1, boolean S2 ){
  
  // Disabling interrupt to respect tight timing
  cli();
  
 
 if(S2) {
   

   
   if(S1) {

     for (i = 0; i < 35; i++) {
       WHITE;
     }
   
     for (i = 0; i < 25; i++) {
     
       WHITE;
     }
     
   } else {
     
     
     for (i = 0; i < 25; i++) {
       BLACK;   
     }
     
     for (i = 0; i < 35; i++) {  
       WHITE;    
     }
   }
   
 } else {

   
   if(S1) {

     for (i = 0; i < 35; i++) {
       WHITE;
     }
    
     for (i = 0; i < 25; i++) {
       BLACK;
     }
   
   } else {
 
     for (i = 0; i < 25; i++) {
       BLACK;
     }
   
     for (i = 0; i < 35; i++) {
       BLACK;
     }
   }
  
 }
 
 
 // Re-enabling interrupts
 sei();
  

}
  
      
void LED_B(int val) {

  if (val == 0) {
   
   BLACK;
  } else if (val == 1) {
  
    GREEN;
  } else if (val == 2) {
  
    RED;
  } else if (val == 3){
  
    BLUE;
  } else {
  
    WHITE;
  }

}
