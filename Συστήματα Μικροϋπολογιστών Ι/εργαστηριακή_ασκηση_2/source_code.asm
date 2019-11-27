;** File Name:          Lab02_8941_8872.asm
;** Group/Team:         5/2
;** Name1/AEM1          Ioannis Mpountouridis 8872
;** Name2/AEM2          Konstantinos Chatziantoniou 8941
;** Description:
;**** Section1:(Password config) -->> No led on
;*************		Store the password by pressing simultaneously the digits(sw1-sw4) and sw7
;*************		Press sw0 to go to Passwd Validation
;**** Section2:(Password validation) -->> led 0 on
;*************		Enter the passwd by pressing the digits in serial.
;*************		Error evens -> Time out after 5 sec || Wrong digit
;*************		1 error -> blink led0 with 1 sec interval  >2 errors -> blink all leds with 1 sec interval
;*************		Enter the correct passwd without error event in between the btn press to enter the sensor mode
;**** Section3:(Sensor Mode) -->> led1 on
;*************		Open coresponding led if button was pressed(triggered sensor) without first pressing the bypass btn
;*************		SW0 resets sensor mode         

.include "m16def.inc"	

.def temp1 = r16
.def temp2 = r17
.def temp3 = r18
.def temp4 = r19
.def passwd = r20
.def time_counter1 = r21
.def time_counter5 = r22
.def timer1 = r23
.def timer2 = r24
.def passwd_temp = r25
.def arg = r26
.def led_function = r27
.def t1cntr_flag = r28

.CSEG

RESET:
	LDI	R16, low(RAMEND)					;** Init stack pointer
	OUT	SPL, R16							;****
	LDI	R16, high(RAMEND)					;****
	OUT	SPH, R16							;****
	ser	temp1								;**	temp1 = 0xFF
	out	DDRB,temp1							;** Set PORTB to output
	ldi temp1 , 0xFF
	out portb , temp1
	ldi passwd , 0x00


PASSWD_IN:
	ldi temp1 , 0x00
	sbis pind, 0x01						;** if sw1 is not pressed skip
	ldi temp1 , 0x01					;** set temp1 if sw1 is pressed
	ldi temp2 , 0x00
	sbis pind , 0x02
	ldi temp2 , 0x02
	ldi temp3 , 0x00
	sbis pind , 0x03
	ldi temp3 , 0x04
	ldi temp4 , 0x00
	sbis pind , 0x04
	ldi temp4 , 0x08
	sbis pind , 0x07					;** if sw7 is not pressed skip
	rjmp SAVE_PASSWD					;** jump to SAVE_PASSWD if sw7 is pressed
	sbis pind , 0x00					;** if sw0 is not pressed skip
	rjmp INIT2							;** jump to INIT2 if sw0 is pressed
	rjmp PASSWD_IN						;** loop back

SAVE_PASSWD:
	sbis pind , 0x07					;** wait for sw7 to be released
	rjmp SAVE_PASSWD
	ldi passwd , 0x00
	add passwd , temp1					;** put the passwd in 1 register
	add passwd , temp2
	add passwd , temp3
	add passwd , temp4
	ldi temp1 , 0x00				
	cp passwd , temp1					;** check if passwd is zero
	breq NO_PASSWD_GIVEN
	rjmp PASSWD_IN						;** go back and wait for other passwd or go to init2

NO_PASSWD_GIVEN:
	ldi temp1 , 0x00					
	out PORTB , temp1					;** blink led if passwd is zero 
	ldi  r18, 21
    ldi  r19, 75
    ldi  r20, 191
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
	ldi temp1 , 0xFF					;** switch off led
	out PORTB , temp1			
	rjmp PASSWD_IN						;** go back to PASSWD_IN

INIT2:
	sbis pind , 0
	rjmp INIT2							;** wait for sw0 to be realeased
	ldi temp1 , 0x00	
	cp temp1 , passwd		
	breq PASSWD_IN						;** if passwd is not given jump back to PASSWD_IN
	ldi temp1 , ~0x01					;** switch on led0 for normal mode
	out portb , temp1
	ldi time_counter1 , 0x0				;** registers inits
	ldi time_counter5 , 0x0
	mov passwd_temp , passwd
	ldi t1cntr_flag , 0x00
	ldi led_function , 0x00
NORMAL_OP:
	rcall TIMER25us						;** delay for 25us
	inc time_counter5					;** increase counter for 5 sec
	inc time_counter1					;** increase counter for 1 sec
	and time_counter1 , t1cntr_flag		;** flag if counting for 1 sec is not necessary yet
	ldi temp1 , 200
	cp time_counter5 , temp1			;** check if 5sec have passed
	breq TIMEOUT						;**** and go to TIMEOUT
	ldi arg , 0x00						;** init arg
	sbis pind , 0x04					;** set arg depanding which button was pressed
	ldi arg , 0x08
	sbis pind , 0x03
	ldi arg , 0x04
	sbis pind , 0x02
	ldi arg , 0x02
	sbis pind , 0x01
	ldi arg , 0x01
	ldi temp1 , 0x00
	cpse arg , temp1					;** if arg = 0 no button was pressed
	rjmp BTN_INPUT						;** skip if no button was pressed
	rcall LED_FUN						;** do led stuff
	ldi temp1 , 0x00					;** check if the whole passwd was given
	cp temp1 , passwd_temp
	breq MID_JUMP						;** go to sensor mode
	rjmp NORMAL_OP




BTN_INPUT:
	rcall TIMER25us
	inc time_counter5
	inc time_counter1
	and time_counter1 , t1cntr_flag		;** delay 25 us, update counters   !!!!!!!!!ADD cOUNTER 1
	rcall LED_FUN						;** update leds
	ldi temp1 , 255
	cp time_counter5 , temp1			;** check for 5sec timeout
	breq TIMEOUT
	ldi temp1 , 0x00
	ldi temp2 , 0x00
	sbic pind , 0x04
	ldi temp2 , 0x08
	add temp1 , temp2
	sbic pind , 0x03
	ldi temp2 , 0x04
	add temp1 , temp2
	sbic pind , 0x02
	ldi temp2 , 0x02
	add temp1 , temp2
	sbic pind , 0x01
	ldi temp2 , 0x01
	add temp1 , temp2
	and temp1 , arg						;** check if arg button was released
	ldi temp2 , 0x00
	cpse temp1 , temp2
	rjmp CHECK_IF_CORRECT				;** if released go to CHECK_IF_CORRECT
	rjmp BTN_INPUT


CHECK_IF_CORRECT:
	mov temp1 , arg						;** save arg
	and temp1 , passwd_temp				;** check if arg(digit) is in passwd
	cpse arg , temp1					;** skip if arg = temp1
	rjmp WRONG_BTN
	sub passwd_temp , arg				;** substract correct digit from passwd
	cp arg , passwd_temp				;** check if another digit should be given first
	brlo WRONG_BTN
	rjmp NORMAL_OP
	


WRONG_BTN:		;merge them
	ldi time_counter5 , 0x00			;** time counter
	ldi t1cntr_flag , 0xFF				;** set time counter for 1 sec, for led blinking for error
	inc led_function					;** count one more error
	mov passwd_temp , passwd			;** reset passwd given
	rjmp NORMAL_OP

TIMEOUT:		;merge them
	ldi time_counter5 , 0x00
	ldi t1cntr_flag , 0xFF
	inc led_function
	mov passwd_temp , passwd
	rjmp NORMAL_OP

LED_FUN:
	ldi temp1 , 0x00				
	cp temp1 , led_function				;** if ledfun == 0 no error was done
	breq RETURN
	ldi temp1 , 0x01					;** one error is done
	cp temp1 , led_function
	breq LED_FUN1						;** for 1 error
	rjmp LED_FUN2						;** for 2 or more errors

RETURN:
	ret

MID_JUMP:
	sbis pind ,0x00
	rjmp MID_JUMP
	rjmp INIT3

LED_FUN1:
	ldi temp1 , 40
	cp temp1 , time_counter1			;** check if one sec has passed
	brlo LF_HI							
	rjmp LF_LO
LF_LO:
	ldi temp1 , ~0x00					;** switch off leds
	out portb , temp1
	ret
LF_HI:
	ldi temp1 , ~0x01					;** switch on leds
	out portb , temp1
	;subi time_counter1 , 60
	ldi temp1 , 100						;**
	cp temp1 , time_counter1
	brlo LF_HI_SKIP
	ldi time_counter1 , 215				;** now time counter after 40x 25us will overflow and go back to zero
LF_HI_SKIP:	ret 


LED_FUN2:
	ldi temp1 , 40						;** same with ledfun1 but swith on all leds
	cp temp1 , time_counter1
	brlo LF_HI2
	rjmp LF_LO2
LF_LO2:
	ldi temp1 , ~0x00
	out portb , temp1
	ret
LF_HI2:
	ldi temp1 , ~0xFF
	out portb , temp1
	;subi time_counter1 , 60
	ldi temp1 , 100
	cp temp1 , time_counter1
	brlo LF_HI_SKIP2
	ldi time_counter1 , 215
LF_HI_SKIP2:	ret  


INIT3:
	ldi temp3 , 0xFF				;** flag for sw3 bypass
	ldi temp4 , 0xFF				;** flag for sw1 bypass
	ldi led_function , ~0x02		;** led init
	out portb ,led_function
	ldi led_function , 0x02
SENSOR_MODE:
	sbis pind, 0x00
	rjmp RESET_NORMAL_MODE
	sbis pind , 0x03
	ldi temp3 , 0x00		;** set flag 0x00 for bypass sw3
	sbis pind , 0x01
	ldi temp4 , 0x00		;** set flag 0x00 for bypass sw1
	ldi temp1 , 0x00		;** init temp1
	sbis pind , 0x07
	ldi temp1 , 0b10000000	;** input from sensors 4-7
	sbis pind , 0x06
	ldi temp1 , 0b01000000
	sbis pind , 0x05
	ldi temp1 , 0b00100000
	sbis pind , 0x04
	ldi temp1 , 0b00010000
	ldi temp2 , 0x00		;** init temp2
	sbis pind , 0x02
	ldi temp2 , 0b00001000	;** input from sensor 2
	and temp2 , temp4
	and temp1 , temp3		;** apply bypass flags
	ldi timer1 , 0x00
	cpse timer1 , temp1
	rjmp ERROR1
	cpse timer1 , temp2
	rjmp ERROR2
	rjmp SENSOR_MODE

	
ERROR1:
	ldi temp2 , 0x00
	ldi timer1 , 0b10000000
	sbic pind , 0x07
	add temp2 , timer1
	ldi timer1 , 0b01000000
	sbic pind , 0x06
	add temp2 , timer1
	ldi timer1 , 0b00100000
	sbic pind , 0x05
	add temp2 , timer1
	ldi timer1 , 0b00010000
	sbic pind , 0x04
	add temp2 , timer1
	and temp2 , temp1
	cpse temp1 , temp2
	rjmp ERROR1								;** wait for key to be released
	mov temp2 , temp1
	and temp2 , led_function				;** check if error led is already open
	cpse temp2 , temp1
	add led_function , temp1
	ori led_function , 0x04					;** switch on led2
	com led_function
	out portb , led_function				;** apply to leds
	com led_function
	rjmp SENSOR_MODE



ERROR2:
	sbis pind , 0x02
	rjmp ERROR2								;** wait for release
	mov temp1 , temp2
	and temp1 , led_function
	cpse temp1 , temp2
	add led_function , temp2			;check if led is already open
	ori led_function , 0x04				;Switch on led2
	com led_function
	out portb , led_function			;apply to leds
	com led_function
	rjmp SENSOR_MODE




RESET_NORMAL_MODE:
	sbis pind ,0x00
	rjmp RESET_NORMAL_MODE
	rjmp INIT3					;!!---- OR go to NORMAL_MODE to retype the password ----!!


; 25ms at 4.0 MHz
TIMER25us:
    ldi  timer1, 130
    ldi  timer2, 222
L2: dec  timer2
    brne L2
    dec  timer1
    brne L2
    ret


