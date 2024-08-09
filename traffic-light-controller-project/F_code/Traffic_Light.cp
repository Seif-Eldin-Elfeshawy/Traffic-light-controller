#line 1 "C:/2nd comm&cs/Summer Training/Embedded Systems/projects/elfeshawy/Final Project/F_code/Traffic_Light.c"
#line 15 "C:/2nd comm&cs/Summer Training/Embedded Systems/projects/elfeshawy/Final Project/F_code/Traffic_Light.c"
char count,left,right,newleft,newright,temp;


void interrupt(){
 if(intf_bit==1){
 intf_bit=0;
 temp=portb;
 while(portb.b0==0){

 if(portb.b1==1){
 portb=0b01000100;
 delay_ms(300);
 portb=0b00110000;
 while(portb.b1==1 &portb.b0==0);
 }
 else{
 portb=0b00101000;
 delay_ms(300);
 portb=0b10000100;
 while(portb.b1==0 &portb.b0==0);
 }
 }
 }
 portb=temp;
}


void display(){
 while(1){
  portb.b2 =1; portb.b7 =1;

 for(count=15;count>0;count--){
 left=count/10;
 right=count%10;
 newleft=(count-3)/10;
 newright=(count-3)%10;
 portc=right;
 porta=left | (0b00000100);
 if(count<=3){
  portb.b7 =0;
  portb.b6 =1;
 portd=right;
 porte=left;
 }
 else{
 portd=newright;
 porte=newleft;
 }
 delay_ms(100);
 }

  portb.b2 =0;  portb.b4 =1;
  portb.b6 =0;  portb.b5 =1;

 for(count=23;count>0;count--){
 left=count/10;
 right=count%10;
 newleft=(count-3)/10;
 newright=(count-3)%10;
 portd=right;
 porte=left;
 if(count<=3){
  portb.b4 =0;
  portb.b3 =1;
 portc=right;
 porta=left | (0b00000100);
 }
 else{
 portc=newright;
 porta=newleft | (0b00000100);
 }
 delay_ms(100);
 }
  portb.b3 =0;  portb.b5 =0;

 }
}


void main(){
 gie_bit=1;
 inte_bit=1;
 intedg_bit=0;

 adcon1=7;

 trisb=3;
 trisc=trisd=trisa=trise=0;

 porta=portb=portc=portd=porte=0;
 porta.b2=1;

 display();

}
