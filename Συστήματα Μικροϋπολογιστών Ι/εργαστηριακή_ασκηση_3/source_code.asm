.include "m16def.inc"	

.dseg
.cseg

;-----------------------------------

InitStackPointer:
	ldi r24, low(RAMEND)
	out spl, r24
	ldi r24, high(RAMEND)
	out sph, r24
 
;-----------------------------------


intro:  

	ldi r16,0xff ; set all bits of r16 to logic 1

	out DDRB,r16 ; set portb as output

	out PORTB,r16 ; turn off all leds	
	
	; WE NEED TO PRESS SW6 TO START

	sbis PIND,0x06 ;if sw6 is not pressed skip line
	 
	jmp check_released ; go to check_released if sw6 is pressed

	jmp intro ; we will escape from here until sw6 is pressed

	;IF WE ARE HERE SW6 WAS PRESSED


	;LETS CHECK WHEN WILL BE RELEASED
	
check_released:

	sbis PIND,0x06 ;if sw6 is released skip line

	jmp check_released

	; IF WE ARE HERE SW6 WAS PRESSED AND RELEASED

	
	clr r4 ; r4 is a counter for 4 sec

	ldi r16,80 ; 80 * 50 ms = 4sec 
	
	mov r5,r16 ; r5: flag to show that 4 seconds passed

	clr r22 ; r22 will beused to save sw2 state

	clr r23 ; r23 will be used to save sw3 state

	clr r24 ; r24 will be used to save sw4 state

	clr r25 ; r25 will be used to save sw5 state
	
	clr r6  ; r6 is a counter for 0.5 sec

	ldi r16,10 ; r16 = 10

	mov r7,r16 ; r7: flag to show that 1 second passed 

	clr r8 ; r8 is a counter for 10 sec

	ldi r16,200  ; r16 = 200
	
	mov r9,r16 ; r9: flag to show that 10 seconds passed
	
	; USER MUST CHOOSE -> SW2 SW3 SW4 SW5
	
	; 10 SECONDS REMAINING 

set_program_10sec: 
	
	rcall Delay50ms	; deleay 50ms

	inc r8 ; r8 = r8 + 1

	cp r8,r9 ; check if 10 seconds passed
	
	breq save_program ;exit if time passed	

	sbis PIND,0x02 ; check if sw2 is pressed
	
	ldi r22,0b00000100
	
	sbis PIND,0x03 ; check if sw3 is pressed
	
	ldi r23,0b00001000	

	sbis PIND,0x04 ; check if sw4 is pressed

	ldi r24,0b00010000

	sbis PIND,0x05 ; check if sw5 is pressed

	ldi r25,0b00100000 

	jmp set_program_10sec ; do it again if time not passed

save_program: 

	; WE NEED TO SAVE PASSWORD IN R21

	clr r8 ; clear counter

	clr r21 ; keep password in r21

	add r21,r22 ; start setting password in r21

	add r21,r23	; ...

	add r21,r24	; ...

	add r21,r25	; end of setting password to r21

	clr r22 	; checker for sw1

overweight_check:
	
	; PRESS SW1 TO ENABLE OVERWEIGHT MODE

	rcall Delay50ms ; delay 50ms

	inc r8 	 ; r8 = r8 + 1
		
	cp r8,r9 ; check if 10 seconds passed

	breq before_start ;10 seconds passed. overweight mode not activated
	
	sbis PIND,0x01 ; check if sw1 was pressed

	jmp check_released_sw1 ;sw1 is now pressed,....

	jmp overweight_check ;

check_released_sw1:;sw1 is now pressed.. checking when will be released

	sbis PIND,0x01 ;if sw1 is released skip line

	jmp check_released_sw1

	ldi r22,0b11111101

	out PORTB,r22 ; turn on led1

	;continue overweight

overweight: ; turn on/off led1 with 1 second period

	rcall Delay50ms

	inc r6

	cp r6,r7 ; 10 * 50 ms = 500 ms 

	breq led_overweight

continue:

	sbis PIND,0x01 ; check if sw1 was pressed

	jmp check_again_released_sw1 ; sw1 pressed... washing machine is ready to start

	jmp overweight ; sw1 not pressed...


led_overweight: ; this label is responsible for changing state of led1

	in r22,PORTB ;get state of led1

	ldi r18,0b00000010 ;r18 is a mask to inverse state of led1

	eor r22,r18 ; inversing state of led1

	out PORTB,r22 ; show state of led1

	clr r6 ; clearing counter
	
	jmp continue ;return to overweight

check_again_released_sw1:

	sbis PIND,0x01 ;if sw1 is released skip line

	jmp check_again_released_sw1

before_start:
	
	; SOME SETTINGS BEFORE WE START

	ser r22 ; mask to turn off leds

	out PORTB,r22 ;turn off all leds

	mov r22,r21 ; get password

	com r22 ; compliment r23

	andi r22,0b00011000 ; get sw3 and sw4 state

	mov r23,r21 ; get password

	com r23 ; compliment r23

	andi r23,0b00100000 ; get sw5 state

	mov r25,r21 ; get password

	;com r25

	andi r25,0b00000100 ; get sw2 state

	clr r10 ; r10 proplisi

	clr r11 ; r11 kyria plisi

	clr r12 ; r12 stragisma

	cpi r22,0b00000000 ; check sw3 and sw4 state

	breq time_add_case0

	cpi r22,0b00001000 ; get sw3 and sw4 state

	breq time_add_case1

	cpi r22,0b00010000 ; get sw3 and sw4 state

	breq time_add_case2

	cpi r22,0b00011000 ; get sw3 and sw4 state

	breq time_add_case3

end_of_cases_0: 
	
	;elegxos gia ksevgalma

	cpi r23,0b00000000 ; get sw5 state

	breq straggisma_0

	cpi r23,0b00100000 ; get sw5 state

	breq straggisma_1

end_of_cases_1:
	
 	cpi r25,0b00000000 ; get sw2 state

	breq proplisi_0

	cpi r25,0b00000100 ; get sw2 state

	breq proplisi_1

end_of_cases_2:

	; otan ftaso edo exo pleon stin diathesi mou

	; ston r10 ton xrono proplisis (tha einai 0 h 4 seconds)

	; ston r11 ton xrono tis kyrias plisis

	; ston r12 exo ena flag gia to an ginei stragisma 

	jmp start

time_add_case0:

	ldi r24,4 ;xronos

	; kyria plisi

	add r11,r24

	jmp end_of_cases_0

time_add_case1:

	ldi r24,8 ;xronos

	; kyria plisi

	add r11,r24

	jmp end_of_cases_0

time_add_case2:

	ldi r24,12 ;xronos

	;kyria plisi

	add r11,r24

	jmp end_of_cases_0

time_add_case3:

	ldi r24,18 ;xronos

	; kyria plisi

	add r11,r24

	jmp end_of_cases_0
   
straggisma_0:

	ldi r24,1

	;stagisma

	add r12,r24

	jmp end_of_cases_1

straggisma_1:

	ldi r24,0

	;stragisma

	add r12,r24

	jmp end_of_cases_1

proplisi_0:

	clr r10	

	; proplisi den epilexthike

	jmp end_of_cases_2

proplisi_1:

	ldi r24,4

	; proplisi epilexthike. Prostheto 4 sec

	add r10,r24

	jmp end_of_cases_2

start:

	;plintirio se leitouria:

	;anavoyme led1

	ldi r24,0b11111100

	out PORTB,r24

	;proplisi

	mov r24,r10
	
	cpi r24,0
	
	breq skip1

	;energopoioume tin proplisi

	;avanoume led0 , led1 kai led2

	ldi r24,0b11111000

	out PORTB,r24
		
	rcall proplisi4sec

	;kapou edo teleionei h proplisi..
		
skip1:

	;energopoioume tin kyria plisi 
	
	;anavoume led0 , led1 kai led3

	ldi r24,0b11110100

	out PORTB,r24

	mov r24,r11

 	rcall kyriaplisi

	;ksevgalma

	ldi r24,0b11101100

	out PORTB,r24

	rcall ksevgalma
	
	;stragisma

	mov r24,r12

	cpi r24,0

	breq skip2

	rcall stragisma

skip2:

	;telos plisis
	
	ldi r24,0b10000000

	com r24

	out PORTB,r24

	rcall Delay5sec

	jmp intro

proplisi4sec:
	
	ldi r24,0b11111000

	out PORTB,r24
		
	rcall Delay50ms

	inc r4 ;

	cp r4,r5 ; check if 4 seconds passed

	breq end_proplisi

	;check if button1 pressed

	sbis PIND,0x00

	rcall error1

	sbis PIND,0x07

	rcall error2

	;check if button2 pressed
	
	jmp proplisi4sec	

end_proplisi:

	ret




error1:

	sbis PIND,0x00 ;wait for sw0 released

	jmp error1

	clr r6 ; counter for 1 second period

	ldi r16,0b11111110 ; settings to turn on led0

	out PORTB,r16 ; turning on led0

end_error1:

	rcall Delay50ms 

	inc r6

	cp r6,r7 ; 10 * 50 ms = 500 ms 

	breq led_door_open

continue_error1:	

	sbic PIND,0x00 

	jmp end_error1

check_released_error1:
		
	sbis PIND,0x00 

	jmp check_released_error1

	ret ; end of error1

error2:

	sbis PIND,0x07 ;wait for sw7 released

	jmp error2

	clr r6

	ldi r16,0b10111101 ;settings to turn on led6 and led1

	out PORTB,r16 ; turn on led1 and led6

end_error2:

	rcall Delay50ms

	inc r6

	cp r6,r7 ; 10 * 50 ms = 500 ms 

	breq led_water

continue_error2:
	
	sbic PIND,0x07 

	jmp end_error2

check_released_error2:
		
	sbis PIND,0x07 

	jmp check_released_error2

	ret ;end of error2

led_door_open:
	
	in r22,PORTB ;get state of led0

	ldi r18,0b00000001 ;r18 is a mask to inverse state of led0

	eor r22,r18 ; inversing state of led0

	out PORTB,r22 ; show state of led0

	clr r6 ; clearing counter

	jmp continue_error1	

led_water:

	in r22,PORTB ;get state of led1 and led6

	ldi r18,0b00000010 ;r18 is a mask to inverse state of led1

	eor r22,r18 ; inversing state of led1

	out PORTB,r22 ; show state of led0

	clr r6 ; clearing counter

	jmp continue_error2	

kyriaplisi:

	ldi r24,0b11110100

	out PORTB,r24

	clr r4
	
	mov r24,r11

	lsl r24

	lsl r24

	lsl r24

	add r24,r11

	add r24,r11
	
	mov r8,r24
	
kyriaplisi_timer:

	ldi r24,0b11110100

	out PORTB,r24
	
	rcall Delay100ms

	inc r4
	
	cp r4,r8
	
	breq end_kyriaplisi

	sbis PIND,0x00

	rcall error1

	sbis PIND,0x07

	rcall error2
	
	jmp kyriaplisi_timer

end_kyriaplisi:			
	
	ret	

ksevgalma:
	
	ldi r24,0b11101100

	out PORTB,r24
	
	clr r4

	ldi r24,10

	mov r8,r24

ksevgalma_timer:
	
	ldi r24,0b11101100

	out PORTB,r24
	
	rcall Delay100ms

	inc r4
	
	cp r4,r8
	
	breq end_ksevgalma

	sbis PIND,0x00

	rcall error1

	sbis PIND,0x07

	rcall error2
	
	jmp ksevgalma_timer

end_ksevgalma:

	ret

stragisma:
	
	ldi r24,0b11011100

	out PORTB,r24
	
	clr r4

	ldi r24,20

	mov r8,r24

stragisma_timer:
	
	ldi r24,0b11011100

	out PORTB,r24
	
	rcall Delay100ms

	inc r4
	
	cp r4,r8
	
	breq end_stragisma

	sbis PIND,0x00

	rcall error1

	sbis PIND,0x07

	rcall error2
	
	jmp stragisma_timer

end_stragisma:

	ret

Delay100ms:
  	ldi  r18, 3
    ldi  r19, 8
    ldi  r20, 120
L100: dec  r20
    brne L100
    dec  r19
    brne L100
    dec  r18
    brne L100
	
	ret
Delay50ms:
	ldi  r18, 2
    ldi  r19, 4
    ldi  r20, 187
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    nop
	ret


Delay1sec:
	ldi  r18, 21
    ldi  r19, 75
    ldi  r20, 191
L2: dec  r20
    brne L2
    dec  r19
    brne L2
    dec  r18
    brne L2
    nop
	ret

Delay5sec:

   ldi  r18, 102
    ldi  r19, 118
    ldi  r20, 194
L111: dec  r20
    brne L111
    dec  r19
    brne L111
    dec  r18
    brne L111
	ret
