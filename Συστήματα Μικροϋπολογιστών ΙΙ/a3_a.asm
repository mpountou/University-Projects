;** File Name:          a3_a.asm
;** Group/Team:         Group E / Team 3
;** Name1/AEM1          Ioannis Mpountouridis / 8872
;** Name2/AEM2          Konstantinos Chatziantoniou / 8941

.include "m16def.inc"
; ----------------- DEFINE VARIABLES -----------------
.def temp = r16       ; temporary variable for general use
.def flag = r17       ; flag used for interrupt
.def holderHigh = r18 ; register to store high byte of period 
.def holderLow = r19  ; register to store low byte of period
.def secCom = r20     ; counter used for 1 second timer
.def ADCHIGH = r21   ; register to store analog to digital result
.def resultL = r22   ; register to store low byte of period
.def resultH = r23   ; register to store high byte of period
; The values will be saved there in pairs (L-H)
; ----------------- DEFINE SAVE ADDRESS -----------------
.equ ArrStartL = 0x00
.equ ArrStartH = 0x01
; ----------------- INTERUPT VECTOR ADDRESSES -----------------
.org 0x0000
    rjmp SETUP
.org 0x0020 
    rjmp INTERRUPT

SETUP:

	; ----------------- INIT STACK POINTER -----------------
	ldi temp, high(RAMEND)
	out SPH, temp
	ldi temp, low(RAMEND)
	out SPL, temp

    ; ----------------- SET LEDS TO PORTA -----------------
    ser temp
    out DDRA, temp
	clr temp ; turn off leds
    out PORTA, temp

    ; ----------------- SET SWITCHES TO PORTD -----------------
    clr temp
    out DDRD, temp

    ; ----------------- SAVE ADDRESS -----------------
    ldi XL, ArrStartL           ; init for array access
    ldi XH, ArrStartH       

MEASURE_AGAIN:

	 ; ----------------- INSTALL TIMER 1 AS COUNTER (PB1) -----------------
     ldi temp, 0b00000111        ; set external pulse (T1) == (PB1)
     out TCCR1B, temp            ; apply settings
     clr temp                    
     out TCCR1A, temp
     out TCNT1H, temp            ; initial value
     out TCNT1L, temp

	 clr secCom ; count 16 times => 1/ 16 sec
	 
	 ldi flag, 0x00              ; singals the main the time window is over
 
    ; ----------------- INSTALL TIMER0 AS CLOCK -----------------
    ;** CPU 8MHZ 
    ;** PRESCALER 1024
    ;** we will count 1/32 sec for 32 times

    ldi temp, 0b00000101        ; setting the prescaler 1024
    out TCCR0, temp
    ldi temp, 0b00001100        ; initial value of clock at 12
    out TCNT0, temp

    ; ----------------- ENABLE TIMER1 OVERFLOW INTERRUPT -----------------
    ldi temp, 1<<TOIE0
    out TIMSK, temp
     
    ; ----------------- ENABLE GLOBAL INTERUPTS -----------------
    sei

MAIN: 
        ; ----------------- WAIT INTERRUPT (EVERY 1/16 SEC) -----------------
        cpi flag, 0xFF
        breq NEXT_FREQ
        rjmp MAIN


INTERRUPT:
        inc secCom      ; 1/16 sec  -- counter
        cpi secCom,16   ; check if 1 sec completed
        brne WAIT_ONE_SEC 
        ; ----------------- DISABLE TIMER0 -----------------
        clr temp
        out TCCR0, temp
        ldi flag, 0xFF   ; change flag to signal main
        in holderLow, TCNT1L
		in holderHigh, TCNT1H   ; Read the counter values
        
        ; ----------------- SAVE RESULT -----------------
        st X+, holderLow
		st X+, holderHigh
		; ----------------- CLEAR TIMER1 -----------------
		clr temp
		out TCNT1H, temp
		out TCNT1L, temp
WAIT_ONE_SEC:
        reti                    ; return from interrupt

    NEXT_FREQ:
        sbis PIND, 2
        rjmp RELEASE_NEXT_FREQ   ; press btn 2 to measure the next frequency
        sbis PIND, 3
        rjmp LOOP_RESULT         ; press btn 3 to go to end and show the values
        rjmp NEXT_FREQ

    RELEASE_NEXT_FREQ:
        sbis PIND, 2             ; wait btn 2 to release
        rjmp RELEASE_NEXT_FREQ

		; **************                           **************
		; ************** IMPLEMENT ADC HERE LATER  **************
		; **************                           **************

        ; ----------------- STORE RESULT OF ADC -----------------
        ldi temp,0xFF 
        st X+,temp  
 
        rjmp MEASURE_AGAIN               
	
        ; ----------------- SHOW VALUES -----------------


LOOP_RESULT:
    cpi XL,0 ; check if all results appeared
    breq end_game ; end of program
	ld ADCHIGH,-X ;pre decrement and load ADCH
	com ADCHIGH ; inverse 
    out PORTA,ADCHIGH ; show ADCH
	rcall sw3_click ; wait to click sw3 for high result
    ld resultH,-X ; pre decrement and load high result  
    com resultH ; inverse 
    out PORTA,resultH ; show high byte result
	rcall sw3_click ; wait to click sw3 for low result 
    ld resultL,-X ; pre decrement and load low result 
    com resultL ; inverse logic
    out PORTA,resultL ; show low byte result
	rcall sw3_click ; wait to click sw3 for high result  
    rjmp LOOP_RESULT 


end_game: 
    rjmp end_game

; ----------------- FUNCTION IMPLEMENTS SW3 CLICK -----------------
sw3_click:
	sbic PIND,3
    rjmp sw3_click
sw3_release:
    sbis PIND,3
    rjmp sw3_release 
	ret
    
