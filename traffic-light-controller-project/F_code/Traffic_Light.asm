
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Traffic_Light.c,18 :: 		void interrupt(){
;Traffic_Light.c,19 :: 		if(intf_bit==1){                          //check which interrupt has occured
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt0
;Traffic_Light.c,20 :: 		intf_bit=0;                            //reset the interrupt flag
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;Traffic_Light.c,21 :: 		temp=portb;                            //store the value of portb in temp to return it after interrupt
	MOVF       PORTB+0, 0
	MOVWF      _temp+0
;Traffic_Light.c,22 :: 		while(portb.b0==0){                    //while the button of Automatic/Manual button is pressed
L_interrupt1:
	BTFSC      PORTB+0, 0
	GOTO       L_interrupt2
;Traffic_Light.c,24 :: 		if(portb.b1==1){                    //west is on
	BTFSS      PORTB+0, 1
	GOTO       L_interrupt3
;Traffic_Light.c,25 :: 		portb=0b01000100;                //turn on the westred and southyellow
	MOVLW      68
	MOVWF      PORTB+0
;Traffic_Light.c,26 :: 		delay_ms(300);                   //delay for southyellow
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_interrupt4:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt4
	DECFSZ     R12+0, 1
	GOTO       L_interrupt4
	DECFSZ     R11+0, 1
	GOTO       L_interrupt4
	NOP
	NOP
;Traffic_Light.c,27 :: 		portb=0b00110000;                //turn off southyellow and westred and turn on westgreen and southred
	MOVLW      48
	MOVWF      PORTB+0
;Traffic_Light.c,28 :: 		while(portb.b1==1 &portb.b0==0); //stay on until change to south or Automatic
L_interrupt5:
	BTFSC      PORTB+0, 1
	GOTO       L__interrupt27
	BCF        112, 0
	GOTO       L__interrupt28
L__interrupt27:
	BSF        112, 0
L__interrupt28:
	BTFSC      PORTB+0, 0
	GOTO       L__interrupt29
	BSF        3, 0
	GOTO       L__interrupt30
L__interrupt29:
	BCF        3, 0
L__interrupt30:
	BTFSS      112, 0
	GOTO       L__interrupt31
	BTFSS      3, 0
	GOTO       L__interrupt31
	BSF        112, 0
	GOTO       L__interrupt32
L__interrupt31:
	BCF        112, 0
L__interrupt32:
	BTFSS      112, 0
	GOTO       L_interrupt6
	GOTO       L_interrupt5
L_interrupt6:
;Traffic_Light.c,29 :: 		}
	GOTO       L_interrupt7
L_interrupt3:
;Traffic_Light.c,31 :: 		portb=0b00101000;                //turn on the southred and westyellow
	MOVLW      40
	MOVWF      PORTB+0
;Traffic_Light.c,32 :: 		delay_ms(300);                   //delay for westyellow
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_interrupt8:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt8
	DECFSZ     R12+0, 1
	GOTO       L_interrupt8
	DECFSZ     R11+0, 1
	GOTO       L_interrupt8
	NOP
	NOP
;Traffic_Light.c,33 :: 		portb=0b10000100;                //turn off westyellow and southred turn on southgreen westhred
	MOVLW      132
	MOVWF      PORTB+0
;Traffic_Light.c,34 :: 		while(portb.b1==0 &portb.b0==0); //stay on until change to west or Automatic
L_interrupt9:
	BTFSC      PORTB+0, 1
	GOTO       L__interrupt33
	BSF        112, 0
	GOTO       L__interrupt34
L__interrupt33:
	BCF        112, 0
L__interrupt34:
	BTFSC      PORTB+0, 0
	GOTO       L__interrupt35
	BSF        3, 0
	GOTO       L__interrupt36
L__interrupt35:
	BCF        3, 0
L__interrupt36:
	BTFSS      112, 0
	GOTO       L__interrupt37
	BTFSS      3, 0
	GOTO       L__interrupt37
	BSF        112, 0
	GOTO       L__interrupt38
L__interrupt37:
	BCF        112, 0
L__interrupt38:
	BTFSS      112, 0
	GOTO       L_interrupt10
	GOTO       L_interrupt9
L_interrupt10:
;Traffic_Light.c,35 :: 		}
L_interrupt7:
;Traffic_Light.c,36 :: 		}
	GOTO       L_interrupt1
L_interrupt2:
;Traffic_Light.c,37 :: 		}
L_interrupt0:
;Traffic_Light.c,38 :: 		portb=temp;                               //return the value of portb that it has before interrupt
	MOVF       _temp+0, 0
	MOVWF      PORTB+0
;Traffic_Light.c,39 :: 		}
L_end_interrupt:
L__interrupt26:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_display:

;Traffic_Light.c,42 :: 		void display(){
;Traffic_Light.c,43 :: 		while(1){
L_display11:
;Traffic_Light.c,44 :: 		westred=1;southgreen=1;            //south is on and west is off
	BSF        PORTB+0, 2
	BSF        PORTB+0, 7
;Traffic_Light.c,46 :: 		for(count=15;count>0;count--){
	MOVLW      15
	MOVWF      _count+0
L_display13:
	MOVF       _count+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_display14
;Traffic_Light.c,47 :: 		left=count/10;                  //represent the left digit for west
	MOVLW      10
	MOVWF      R4+0
	MOVF       _count+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__display+3
	MOVF       FLOC__display+3, 0
	MOVWF      _left+0
;Traffic_Light.c,48 :: 		right=count%10;                 //represent the right digit for west
	MOVLW      10
	MOVWF      R4+0
	MOVF       _count+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FLOC__display+2
	MOVF       FLOC__display+2, 0
	MOVWF      _right+0
;Traffic_Light.c,49 :: 		newleft=(count-3)/10;           //represent the left digit for south
	MOVLW      3
	SUBWF      _count+0, 0
	MOVWF      FLOC__display+0
	CLRF       FLOC__display+1
	BTFSS      STATUS+0, 0
	DECF       FLOC__display+1, 1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__display+0, 0
	MOVWF      R0+0
	MOVF       FLOC__display+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _newleft+0
;Traffic_Light.c,50 :: 		newright=(count-3)%10;          //represent the right digit for south
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__display+0, 0
	MOVWF      R0+0
	MOVF       FLOC__display+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _newright+0
;Traffic_Light.c,51 :: 		portc=right;
	MOVF       FLOC__display+2, 0
	MOVWF      PORTC+0
;Traffic_Light.c,52 :: 		porta=left | (0b00000100);      //or operator to maintain the value of RA2 one forever to make segments on
	MOVLW      4
	IORWF      FLOC__display+3, 0
	MOVWF      PORTA+0
;Traffic_Light.c,53 :: 		if(count<=3){                   //check when the southyellow is on
	MOVF       _count+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_display16
;Traffic_Light.c,54 :: 		southgreen=0;
	BCF        PORTB+0, 7
;Traffic_Light.c,55 :: 		southyellow=1;
	BSF        PORTB+0, 6
;Traffic_Light.c,56 :: 		portd=right;
	MOVF       _right+0, 0
	MOVWF      PORTD+0
;Traffic_Light.c,57 :: 		porte=left;
	MOVF       _left+0, 0
	MOVWF      PORTE+0
;Traffic_Light.c,58 :: 		}
	GOTO       L_display17
L_display16:
;Traffic_Light.c,60 :: 		portd=newright;
	MOVF       _newright+0, 0
	MOVWF      PORTD+0
;Traffic_Light.c,61 :: 		porte=newleft;
	MOVF       _newleft+0, 0
	MOVWF      PORTE+0
;Traffic_Light.c,62 :: 		}
L_display17:
;Traffic_Light.c,63 :: 		delay_ms(100);                   //delay for displaying the number on segments
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_display18:
	DECFSZ     R13+0, 1
	GOTO       L_display18
	DECFSZ     R12+0, 1
	GOTO       L_display18
	DECFSZ     R11+0, 1
	GOTO       L_display18
	NOP
;Traffic_Light.c,46 :: 		for(count=15;count>0;count--){
	DECF       _count+0, 1
;Traffic_Light.c,64 :: 		}
	GOTO       L_display13
L_display14:
;Traffic_Light.c,66 :: 		westred=0; westgreen=1;            //west is on
	BCF        PORTB+0, 2
	BSF        PORTB+0, 4
;Traffic_Light.c,67 :: 		southyellow=0; southred=1;         //south is off
	BCF        PORTB+0, 6
	BSF        PORTB+0, 5
;Traffic_Light.c,69 :: 		for(count=23;count>0;count--){
	MOVLW      23
	MOVWF      _count+0
L_display19:
	MOVF       _count+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_display20
;Traffic_Light.c,70 :: 		left=count/10;                  //represent the left digit for south
	MOVLW      10
	MOVWF      R4+0
	MOVF       _count+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__display+3
	MOVF       FLOC__display+3, 0
	MOVWF      _left+0
;Traffic_Light.c,71 :: 		right=count%10;                 //represent the right digit for south
	MOVLW      10
	MOVWF      R4+0
	MOVF       _count+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      FLOC__display+2
	MOVF       FLOC__display+2, 0
	MOVWF      _right+0
;Traffic_Light.c,72 :: 		newleft=(count-3)/10;           //represent the left digit for west
	MOVLW      3
	SUBWF      _count+0, 0
	MOVWF      FLOC__display+0
	CLRF       FLOC__display+1
	BTFSS      STATUS+0, 0
	DECF       FLOC__display+1, 1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__display+0, 0
	MOVWF      R0+0
	MOVF       FLOC__display+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _newleft+0
;Traffic_Light.c,73 :: 		newright=(count-3)%10;          //represent the right digit for west
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__display+0, 0
	MOVWF      R0+0
	MOVF       FLOC__display+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _newright+0
;Traffic_Light.c,74 :: 		portd=right;
	MOVF       FLOC__display+2, 0
	MOVWF      PORTD+0
;Traffic_Light.c,75 :: 		porte=left;
	MOVF       FLOC__display+3, 0
	MOVWF      PORTE+0
;Traffic_Light.c,76 :: 		if(count<=3){                   //check when the westyellow is on
	MOVF       _count+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_display22
;Traffic_Light.c,77 :: 		westgreen=0;
	BCF        PORTB+0, 4
;Traffic_Light.c,78 :: 		westyellow=1;
	BSF        PORTB+0, 3
;Traffic_Light.c,79 :: 		portc=right;
	MOVF       _right+0, 0
	MOVWF      PORTC+0
;Traffic_Light.c,80 :: 		porta=left  | (0b00000100);  //or operator to maintain the value of RA2 one forever to make segments on
	MOVLW      4
	IORWF      _left+0, 0
	MOVWF      PORTA+0
;Traffic_Light.c,81 :: 		}
	GOTO       L_display23
L_display22:
;Traffic_Light.c,83 :: 		portc=newright;
	MOVF       _newright+0, 0
	MOVWF      PORTC+0
;Traffic_Light.c,84 :: 		porta=newleft  | (0b00000100); //or operator to maintain the value of RA2 one forever to make segments on
	MOVLW      4
	IORWF      _newleft+0, 0
	MOVWF      PORTA+0
;Traffic_Light.c,85 :: 		}
L_display23:
;Traffic_Light.c,86 :: 		delay_ms(100);                     //delay for displaying the number on segments
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_display24:
	DECFSZ     R13+0, 1
	GOTO       L_display24
	DECFSZ     R12+0, 1
	GOTO       L_display24
	DECFSZ     R11+0, 1
	GOTO       L_display24
	NOP
;Traffic_Light.c,69 :: 		for(count=23;count>0;count--){
	DECF       _count+0, 1
;Traffic_Light.c,87 :: 		}
	GOTO       L_display19
L_display20:
;Traffic_Light.c,88 :: 		westyellow=0; southred=0;            //prepare to restart the loop again
	BCF        PORTB+0, 3
	BCF        PORTB+0, 5
;Traffic_Light.c,90 :: 		}
	GOTO       L_display11
;Traffic_Light.c,91 :: 		}
L_end_display:
	RETURN
; end of _display

_main:

;Traffic_Light.c,94 :: 		void main(){
;Traffic_Light.c,95 :: 		gie_bit=1;                            //enable the global interrupt enable
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Traffic_Light.c,96 :: 		inte_bit=1;                           //enable the RB0 interrupt enable
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;Traffic_Light.c,97 :: 		intedg_bit=0;                         //determine the edge of interrupt
	BCF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
;Traffic_Light.c,99 :: 		adcon1=7;                             //enable porta and porte to be digital i/o ports
	MOVLW      7
	MOVWF      ADCON1+0
;Traffic_Light.c,101 :: 		trisb=3;                              //determine RB0 and RB1 as input and the other digits output
	MOVLW      3
	MOVWF      TRISB+0
;Traffic_Light.c,102 :: 		trisc=trisd=trisa=trise=0;            //determine other ports as output
	CLRF       TRISE+0
	MOVF       TRISE+0, 0
	MOVWF      TRISA+0
	MOVF       TRISA+0, 0
	MOVWF      TRISD+0
	MOVF       TRISD+0, 0
	MOVWF      TRISC+0
;Traffic_Light.c,104 :: 		porta=portb=portc=portd=porte=0;      //initialize all output ports as zero
	CLRF       PORTE+0
	MOVF       PORTE+0, 0
	MOVWF      PORTD+0
	MOVF       PORTD+0, 0
	MOVWF      PORTC+0
	MOVF       PORTC+0, 0
	MOVWF      PORTB+0
	MOVF       PORTB+0, 0
	MOVWF      PORTA+0
;Traffic_Light.c,105 :: 		porta.b2=1;                           //make the segments on
	BSF        PORTA+0, 2
;Traffic_Light.c,107 :: 		display();                            //call the display() function to start traffic light system
	CALL       _display+0
;Traffic_Light.c,109 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
