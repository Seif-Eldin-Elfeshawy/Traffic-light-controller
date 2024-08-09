/*
  traffic light system using pic16f877a
  ----> Seif Eldin Elsayed Adbelsattar Hassan Elfeshawy <----
*/

//definition of traffic light ports
#define westred portb.b2
#define westyellow portb.b3
#define westgreen portb.b4
#define southred portb.b5
#define southyellow portb.b6
#define southgreen portb.b7

//definition of used variables
char count,left,right,newleft,newright,temp;

//function of interrupt
void interrupt(){
   if(intf_bit==1){                          //check which interrupt has occured
      intf_bit=0;                            //reset the interrupt flag
      temp=portb;                            //store the value of portb in temp to return it after interrupt
      while(portb.b0==0){                    //while the button of Automatic/Manual button is pressed
      //check which street is
         if(portb.b1==1){                    //west is on
            portb=0b01000100;                //turn on the westred and southyellow
            delay_ms(300);                   //delay for southyellow
            portb=0b00110000;                //turn off southyellow and westred and turn on westgreen and southred
            while(portb.b1==1 &portb.b0==0); //stay on until change to south or Automatic
         }
         else{                               //south is on
            portb=0b00101000;                //turn on the southred and westyellow
            delay_ms(300);                   //delay for westyellow
            portb=0b10000100;                //turn off westyellow and southred turn on southgreen westhred
            while(portb.b1==0 &portb.b0==0); //stay on until change to west or Automatic
         }
      }
   }
   portb=temp;                               //return the value of portb that it has before interrupt
}

//function of Automatic display
void display(){
   while(1){
      westred=1;southgreen=1;            //south is on and west is off
      //count to 15 secs for westred
      for(count=15;count>0;count--){
         left=count/10;                  //represent the left digit for west
         right=count%10;                 //represent the right digit for west
         newleft=(count-3)/10;           //represent the left digit for south
         newright=(count-3)%10;          //represent the right digit for south
         portc=right;
         porta=left | (0b00000100);      //or operator to maintain the value of RA2 one forever to make segments on
         if(count<=3){                   //check when the southyellow is on
            southgreen=0;
            southyellow=1;
            portd=right;
            porte=left;
         }
         else{
            portd=newright;
            porte=newleft;
         }
         delay_ms(100);                   //delay for displaying the number on segments
      }
      
      westred=0; westgreen=1;            //west is on
      southyellow=0; southred=1;         //south is off
      //count to 23 secs for southred
      for(count=23;count>0;count--){
         left=count/10;                  //represent the left digit for south
         right=count%10;                 //represent the right digit for south
         newleft=(count-3)/10;           //represent the left digit for west
         newright=(count-3)%10;          //represent the right digit for west
         portd=right;
         porte=left;
         if(count<=3){                   //check when the westyellow is on
            westgreen=0;
            westyellow=1;
            portc=right;
            porta=left  | (0b00000100);  //or operator to maintain the value of RA2 one forever to make segments on
         }
         else{
            portc=newright;
            porta=newleft  | (0b00000100); //or operator to maintain the value of RA2 one forever to make segments on
         }
         delay_ms(100);                     //delay for displaying the number on segments
      }
      westyellow=0; southred=0;            //prepare to restart the loop again

   }
}

//main function
void main(){
     gie_bit=1;                            //enable the global interrupt enable
     inte_bit=1;                           //enable the RB0 interrupt enable
     intedg_bit=0;                         //determine the edge of interrupt
     
     adcon1=7;                             //enable porta and porte to be digital i/o ports
     
     trisb=3;                              //determine RB0 and RB1 as input and the other digits output
     trisc=trisd=trisa=trise=0;            //determine other ports as output
     
     porta=portb=portc=portd=porte=0;      //initialize all output ports as zero
     porta.b2=1;                           //make the segments on

     display();                            //call the display() function to start traffic light system

}