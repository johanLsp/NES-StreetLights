
 
 // #include "avr/io.h"
 #define NOP __asm__("nop\n\t")
 
 
 // Should use PORTA as defined in avr/iomxx0_1.h, but the IDE doesn't like it..  So : PORTA = _SFR_IO8(0X02) 
 
 //#define _SFR_IO8(io_addr) ((io_addr) + __SFR_OFFSET)
 
 
// #define WRITE_HIGH __asm__("SBI  0x22 , 3\n\t")
 //#define WRITE_LOW __asm__("CBI 0x22, 3\n\t")
 
 //#define SET_TMP_REG __asm(" \n\t ldi r27, 0x0\n\t")
  #define WRITE_HIGH __asm__("ldi  r30, 0x4;\n\t out      0x02, r30\n\t")
 #define WRITE_LOW __asm__("ldi  r30, 0x4;\n\t out      0x02, r27\n\t")
 
 
 #define WRITE_0 WRITE_HIGH; NOP; WRITE_LOW; NOP; NOP; NOP; NOP; NOP
 #define WRITE_1 WRITE_HIGH; NOP; NOP; NOP; NOP; WRITE_LOW; NOP; NOP
 
  #define WRITE_BYTE_0 WRITE_0; WRITE_0; WRITE_0; WRITE_0; WRITE_0; WRITE_0; WRITE_0; WRITE_0 // 0b00000000
  #define WRITE_BYTE_1 WRITE_0; WRITE_0; WRITE_1; WRITE_1; WRITE_1; WRITE_1; WRITE_1; WRITE_1 // 0b00111111 Not fully lit up to avoid consuming too much
  
  #define BLACK   WRITE_BYTE_0; WRITE_BYTE_0; WRITE_BYTE_0
  #define WHITE   WRITE_BYTE_1; WRITE_BYTE_1; WRITE_BYTE_1
  #define GREEN   WRITE_BYTE_1; WRITE_BYTE_0; WRITE_BYTE_0 
  #define RED     WRITE_BYTE_0; WRITE_BYTE_1; WRITE_BYTE_0 
  #define BLUE    WRITE_BYTE_0; WRITE_BYTE_0; WRITE_BYTE_1 
  
  
  
 uint8_t bit;
 volatile uint8_t *out;
 
 long previous;
  int k = 0;
void setup()
{

pinMode(DIGITAL2,OUTPUT);
digitalWrite(DIGITAL2,LOW);
USB.begin();
 
  // Printing a message, remember to open 'Serial Monitor' to be able to see this message
  USB.println("CPU freq : ");
  USB.println(F_CPU);
  



  
  
  
     bit = digitalPinToBitMask(DIGITAL2);
  /* 
  uint8_t port = digitalPinToPort(DIGITAL1);
  out = portOutputRegister(port);
  USB.println("out addr : ");
  USB.println((int)out, HEX);
  
   port = digitalPinToPort(DIGITAL2);
  out = portOutputRegister(port);
  USB.println("out addr : ");
  USB.println((int)out, HEX);
  
   port = digitalPinToPort(DIGITAL3);
  out = portOutputRegister(port);
  USB.println("out addr : ");
  USB.println((int)out, HEX);
  
  port = digitalPinToPort(DIGITAL4);
  out = portOutputRegister(port);
  USB.println("out addr : ");
  USB.println((int)out, HEX);
  
  port = digitalPinToPort(DIGITAL5);
  out = portOutputRegister(port);
  USB.println("out addr : ");
  USB.println((int)out, HEX);
  
  port = digitalPinToPort(DIGITAL6);
  out = portOutputRegister(port);
  USB.println("out addr : ");
  USB.println((int)out, HEX);
  
  port = digitalPinToPort(DIGITAL7);
  out = portOutputRegister(port);
  USB.println("out addr : ");
  USB.println((int)out, HEX);
  
  port = digitalPinToPort(DIGITAL8);
  out = portOutputRegister(port);
  USB.println("out addr : ");
  USB.println((int)out, HEX);*/
 

  
  
   uint8_t port = digitalPinToPort(DIGITAL2);

	






	out = portOutputRegister(port);


previous = 0;
//SET_TMP_REG;
  
}

void loop()
{
  //sendByte(0b11111111);
 
  
  if( millis() - previous > 500) {
    
    if (k == 0) {
    cli();    // disable all interrupts => atomicity
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    test_LED(0);
    test_LED(1);
    
    test_LED(2);
    test_LED(0);
    test_LED(1);
    test_LED(2);
    sei();  // re-enable all interrupts
    k = 1;
    } else {
      
      cli();    // disable all interrupts => atomicity
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    
    test_LED(4);
    test_LED(4);
    test_LED(4);
    test_LED(4);
    sei();  // re-enable all interrupts
    k = 0;
    }

    
    
    
   previous = millis(); 
  }
}



void test_LED(int val) {

if (val == 0) {
  GREEN;
} else if (val == 1) {
  RED;
} else if (val == 2){
  BLUE;
} else {
  WHITE;
}

  
      
  
  
  
}

void sendByte(byte b) {
  byte i=8;
  do {
    if ((b&0x80)==0) {
      
      
      
      
    } else {
      
      WRITE_HIGH;
      NOP;
      NOP;
      NOP;
      NOP;
      
      WRITE_LOW;
      NOP;
      NOP;
      
      
      
    } 
    
    b = b+b;
  } while (--i!=0);
      // Send a '0'
   /*   if (F_CPU==16000000L) {
        
      digitalWrite(DIGITAL3,HIGH);
        NOP;// Hi (start)
        NOP;NOP;            // Hi
        
       digitalWrite(DIGITAL3,LOW);
        NOP;// Lo (250ns)
        NOP;NOP;            // Lo
        NOP;NOP;            // Lo (500ns)
      }
      
      else if (F_CPU==8000000L) {
        
*/




/*	

*out = 0b100;
WRITE_LOW;

*out = 0b100;
WRITE_LOW;

*out = 0b100;
WRITE_LOW;

*out = 0b100;
WRITE_LOW;
*/

/*
*out = 0b100;

*out = 0b000;

*out = 0b100;

*out = 0b000;

*out = 0b100;

*out = 0b000;

*out = 0b100;

*out = 0b000;
*/
    /* WRITE_HIGH;
      WRITE_LOW;
      
      WRITE_HIGH;
      WRITE_LOW;
      
      WRITE_HIGH;
      WRITE_LOW;
      
      WRITE_HIGH;
      WRITE_LOW;
      
      WRITE_HIGH;
      WRITE_LOW;*/

/*
	*out = 0b100;
        NOP;
        NOP;
        
	*out = 0b000;

    
	*out = 0b100;

	*out = 0b000;
	*/
       // digitalWrite(DIGITAL3,HIGH);  // Hi (start)
            // Hi
       // digitalWrite(DIGITAL3,LOW); // Lo (250ns)
               // Lo (750ns)
   //   }
  //  }
   // else {
      // Send a '1'
   /*   if (F_CPU==16000000L) {
        digitalWrite(DIGITAL3,HIGH);// Hi (start)
        NOP;NOP;            // Hi
        NOP;NOP;            // Hi (250ns)
        NOP;NOP;            // Hi
        NOP;NOP;            // Hi (500ns)
        digitalWrite(DIGITAL3,LOW);    // Lo (625ns)
      }
      else if (F_CPU==8000000L) {*/
      
      
       // digitalWrite(DIGITAL3,HIGH);  // Hi (start)
              // Hi (data bit here!)
        //digitalWrite(DIGITAL3,LOW);  // Lo (750ns)
        
      /*  	*out &= ~bit;
        NOP;
	*out |= bit;*/

//	*out &= 0b01111;

    
	//*out = 0b10000;
     // }
 //   }
  //  b = b+b;
  //} while (--i!=0);
}
