/*
*
* Waspmote Xbee Receiver final
*
*/







  #define NOP __asm__("nop\n\t")
  
  
 #define HIGH_A __asm__("ldi r30, 0x4;\n\t out 0x02, r30\n\t")
 #define LOW_A __asm__("ldi r30, 0x00;\n\t out 0x02, r30\n\t")
 
 #define HIGH_B __asm__("ldi r30, 0x30;\n\t out 0x08, r30\n\t")
 #define LOW_B __asm__("ldi r30, 0x00;\n\t out 0x08, r30\n\t")
 
 
 #define A_0 HIGH_A; NOP; LOW_A; NOP; NOP; NOP; NOP; NOP
 #define A_1 HIGH_A; NOP; NOP; NOP; NOP; LOW_A; NOP; NOP
 
 #define B_0 HIGH_B; NOP; LOW_B; NOP; NOP; NOP; NOP; NOP
 #define B_1 HIGH_B; NOP; NOP; NOP; NOP; LOW_B; NOP; NOP
 
 #define BYTE_0_A A_0; A_0; A_0; A_0; A_0; A_0; A_0; A_0 // 0b00000000
 #define BYTE_1_A A_0; A_0; A_0; A_1; A_1; A_1; A_1; A_1 // 0b00011111 Not fully lit up to avoid consuming too much
  
 #define BYTE_0_B B_0; B_0; B_0; B_0; B_0; B_0; B_0; B_0 // 0b00000000
 #define BYTE_1_B B_0; B_0; B_0; B_1; B_1; B_1; B_1; B_1 // 0b00011111 Not fully lit up to avoid consuming too much
  
 #define BLACK_A BYTE_0_A; BYTE_0_A; BYTE_0_A
 #define WHITE_A BYTE_1_A; BYTE_1_A; BYTE_1_A
 #define GREEN_A BYTE_1_A; BYTE_0_A; BYTE_0_A
 #define RED_A BYTE_0_A; BYTE_1_A; BYTE_0_A
 #define BLUE_A BYTE_0_A; BYTE_0_A; BYTE_1_A
  
 #define BLACK_B BYTE_0_B; BYTE_0_B; BYTE_0_B
 #define WHITE_B BYTE_1_B; BYTE_1_B; BYTE_1_B
 #define GREEN_B BYTE_1_B; BYTE_0_B; BYTE_0_B
 #define RED_B BYTE_0_B; BYTE_1_B; BYTE_0_B
 #define BLUE_B BYTE_0_B; BYTE_0_B; BYTE_1_B
 
 
 // configuration
 #define SENSTHRESH 10 // Threshold for detecting
 #define DELAYT 200 // Delay after polling pin
 #define DIGITALPIN DIGITAL1 // Input Pin definition

 
 // global variables
 packetXBee *paq_sent;
 int8_t state = 0;
 long previous = 0;
 long timerS1, timerS2, timerN1, timerN2, timerN3, senseTime;
 uint8_t destination[8];
 uint8_t i = 0;
 uint8_t PANID[2] = {0x12,0x34};
 char *KEY = "WaspmoteKey";
 long macAddr;
 int sens_counter;
 boolean ledS1, ledS2;
 boolean detectN1, detectN2, detectN3;

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
 
  pinMode(DIGITAL7,OUTPUT);
  digitalWrite(DIGITAL7,LOW);

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
  // get sensor value
/*  if( digitalRead(DIGITALPIN) )
  {
   sens_counter++;
  }*/
  
  
 
    
    

  
  
  /*
  if( sens_counter > SENSTHRESH )
  {
    XBee.print("N1 : detection");
    XBee.println("");
    sens_counter = 0;
    timerN1 = millis();
    
    if ((millis() - timerN2) >= 5000) {
        timerS1 = millis();
    }
  }*/
  
  if( XBee.available() )
  { 
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
      /*
      XBee.print(printf("Received : %d", packetId));
      XBee.println("");
      */
   
      switch(packetId) {
       case 2 :
         timerN2 = millis();
          
         XBee.print("N2 : detection");
      
         XBee.println("");
          
          detectN1 = (millis() - timerN1) < 5000;
          detectN3 = (millis() - timerN3) < 5000;
          
          if(detectN1 && detectN3) {
            timerS1 = millis();
            timerS2 = millis();
          } else if (detectN1 && !detectN3) {
           timerS2 = millis();
          } else if (!detectN1 && detectN3) {
           timerS1 = millis();
          } else {
            timerS1 = millis();
            timerS2 = millis();
          }
    
          break;
        
        case 3 :
          timerN3 = millis();
          
              XBee.print("N3 : detection");
   XBee.println("");
          if ((millis() - timerN2) >= 5000) {
            timerS2 = millis();
          }
        break;
              
       }
       
       // switch( MAC or PID)
       // case 1: light up section 1
         // set some sort of lock, no new message of ID1 will activate the leds again, only once for some time
       // case 2: light up section 2
       // case 3: light up section 3
       
       // print stuff from example
   /* XBee.print("Network Address Source: ");
XBee.print(xbee868.packet_finished[xbee868.pos-1]->naS[0],HEX);
XBee.print(xbee868.packet_finished[xbee868.pos-1]->naS[1],HEX);
XBee.println("");
XBee.print("MAC Address Source: ");
for(int b=0;b<4;b++)
{
XBee.print(xbee868.packet_finished[xbee868.pos-1]->macSH[b],HEX);
}
for(int c=0;c<4;c++)
{
XBee.print(xbee868.packet_finished[xbee868.pos-1]->macSL[c],HEX);
}
XBee.println("");
XBee.print("Network Address Origin: ");
XBee.print(xbee868.packet_finished[xbee868.pos-1]->naO[0],HEX);
XBee.print(xbee868.packet_finished[xbee868.pos-1]->naO[1],HEX);
XBee.println("");
XBee.print("MAC Address Origin: ");
for(int d=0;d<4;d++)
{
XBee.print(xbee868.packet_finished[xbee868.pos-1]->macOH[d],HEX);
}
for(int e=0;e<4;e++)
{
XBee.print(xbee868.packet_finished[xbee868.pos-1]->macOL[e],HEX);
}
XBee.println("");
XBee.print("RSSI: ");
XBee.print(xbee868.packet_finished[xbee868.pos-1]->RSSI,HEX);
XBee.println("");
XBee.print("16B(0) or 64B(1): ");
XBee.print(xbee868.packet_finished[xbee868.pos-1]->mode,HEX);
XBee.println("");
XBee.print("Data: ");
for(int f=0;f<xbee868.packet_finished[xbee868.pos-1]->data_length;f++)
{
XBee.print(xbee868.packet_finished[xbee868.pos-1]->data[f],BYTE);
}
XBee.println("");
XBee.print("PacketID: ");
XBee.print(xbee868.packet_finished[xbee868.pos-1]->packetID,HEX);
XBee.println("");
XBee.print("Type Source ID: ");
XBee.print(xbee868.packet_finished[xbee868.pos-1]->typeSourceID,HEX);
XBee.println("");
XBee.print("Network Identifier Origin: ");
for(int g=0;g<4;g++)
{
XBee.print(xbee868.packet_finished[xbee868.pos-1]->niO[g],BYTE);
}
XBee.println("");
*/
       // finish
       free( xbee868.packet_finished[xbee868.pos-1] );
       xbee868.packet_finished[xbee868.pos-1] = NULL;
       xbee868.pos--;
     }
   }
   

  } else {
    
    
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
    timerN1 = millis();
    
    if ((millis() - timerN2) >= 5000) {
        timerS1 = millis();
    }
      
    }
     
    
    
    
    
  }
  
  }
  
  
     // here the led stuff?
   
  if(millis() - timerS1 >= 5000 && ledS1) {
   // lightA(false, ledS2);
    lightB(false, ledS2);
    XBee.print("S1 : Off");
   XBee.println("");
    ledS1 = false;
  } else if (millis() - timerS1 < 5000 && !ledS1) {
    //lightA(true, ledS2);
    lightB(true, ledS2);
    XBee.print("S1 : On");
   XBee.println("");
    ledS1 = true;
  }
  
    if(millis() - timerS2 >= 5000 && ledS2) {
  // lightA(ledS1, false);
    lightB(ledS1, false);
    ledS2 = false;
    XBee.print("S2 : Off");
   XBee.println("");
  } else if (millis() - timerS2 < 5000 && !ledS2) {
   // lightA(ledS1, true);
    lightB(ledS1, true);
    XBee.print("S2 : On");
   XBee.println("");
    ledS2 = true;
  }
   
   
   
}



void lightA(boolean S1, boolean S2 ){
  
  
  
  cli();
 if(S2) {
   
   for (i = 0; i < 35; i++) {
     LED_A(4);
   }
   
   if(S1) {
     
    for (i = 0; i < 25; i++) {
     
       LED_A(4);
     }
   } else {
      for (i = 0; i < 25; i++) {
     
       LED_A(0);
     
     }
   }
   
   
  
  
 } else {
      for (i = 0; i < 25; i++) {
     LED_A(0);
   }
   
   
   if(S1) {
     
           for (i = 0; i < 35; i++) {
     LED_A(4);
   }
   } else {
     for (i = 0; i < 35; i++) {
     LED_A(0);
   }
   }
  
 }
 
 sei();
  
  
}



void lightB(boolean S1, boolean S2 ){
  
  
  
  cli();
  
 
 if(S2) {
   

   
   if(S1) {
     
     XBee.print("1, 1");
     XBee.println("");
     
        for (i = 0; i < 35; i++) {
     WHITE_B;
   }
   
   
    for (i = 0; i < 25; i++) {
     
       WHITE_B;
     }
   } else {
     
     
     XBee.print("0, 1");
     XBee.println("");
     /*LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4);
     LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4);
     LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4);
     LED_B(4); LED_B(4); LED_B(4); LED_B(4); LED_B(4);
     
     LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0);
     LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0);
     LED_B(0); LED_B(0); LED_B(0); LED_B(0); LED_B(0);*/
        for (i = 0; i < 25; i++) {
     BLACK_B;
     
   }
      for (i = 0; i < 35; i++) {
     
       WHITE_B;
     
     }
   }
   
   
  
  
 } else {

   
   if(S1) {
     
     XBee.print("1, 0");
     XBee.println("");

   
           for (i = 0; i < 35; i++) {
     WHITE_B;
   }
   
   
   for (i = 0; i < 25; i++) {
     BLACK_B;
   }
   } else {
     
     XBee.print("0, 0");
     XBee.println("");
     
           for (i = 0; i < 25; i++) {
     BLACK_B;
   }
   
     for (i = 0; i < 35; i++) {
     BLACK_B;
   }
   }
  
 }
 
 sei();
  

}


void LED_A(int val) {

if (val == 0) {
 
 BLACK_A;
} else if (val == 1) {
  GREEN_A;

} else if (val == 2) {
  RED_A;

} else if (val == 3){
  BLUE_A;

} else {
  WHITE_A;

}
}

  
      
void LED_B(int val) {

if (val == 0) {
 
 BLACK_B;
} else if (val == 1) {

  GREEN_B;
} else if (val == 2) {

  RED_B;
} else if (val == 3){

  BLUE_B;
} else {

  WHITE_B;
}

}
