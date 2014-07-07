/*
*
*          Waspmote Xbee Receiver
*
*/

 
 // global variables
 packetXBee *paq_sent;
 int8_t state = 0;
 long previous = 0;
 char *data = "I'm the receiver!";
 uint8_t destination[8];
 uint8_t i = 0;
 uint8_t PANID[2] = {0x12,0x34};
 char *KEY = "WaspmoteKey";

void setup()
{  
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
   xbee868.treatData();
   
   if( !xbee868.error_RX )
   {
     while( xbee868.pos > 0 )
     {
       // print stuff from example
       XBee.print("Network Address Source: ");
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
          
       // finish
       free( xbee868.packet_finished[xbee868.pos-1] );
       xbee868.packet_finished[xbee868.pos-1] = NULL;
       xbee868.pos--;
     }
   }
  }
}
