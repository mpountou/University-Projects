;** File Name:          a3_b.asm
;** Group/Team:         Group E / Team 3
;** Name1/AEM1          Ioannis Mpountouridis / 8872
;** Name2/AEM2          Konstantinos Chatziantoniou / 8941
 
.include "m16def.inc"
.cseg


; ----------------- DEFINE VARIABLES -----------------
.def capture1L = r22 ; register to store low input-capture byte
.def capture1H = r23 ; register to store high input-capture byte
.def capture2L = r24 ; register to store low input-capture byte
.def capture2H = r25 ; register to store high input-capture byte
.def resultL = r19   ; register to store low byte of period
.def resultH = r20   ; register to store high byte of period
.def tmp = r16       ; temporary variable for general use
.def flag = r17      ; counter used to capture 5 interrupts
.def ADCHIGH = r18   ; register to store analog to digital result
; ----------------- DEFINE SAVE ADDRESS -----------------
.equ ArrayH = 0x01 
.equ ArrayL = 0x00
; ----------------- INTERUPT VECTOR ADDRESSES -----------------
.org 0x0000
	rjmp main
.org 0x000A
	rjmp INTERUPT


main:

    ; ----------------- INIT STACK POINTER -----------------
    ldi tmp, high(RAMEND)
	out SPH, tmp
	ldi tmp, low(RAMEND)
	out SPL, tmp
    
    ; ----------------- SET ADC TO PORTA (FOR LATER USE) -----------------
	clr tmp
	out DDRA,tmp	

	; ----------------- SET SWITCHES TO PORTD -----------------
	clr tmp
	out DDRD,tmp
   
    ; ----------------- LOAD SΤORE ADDRESS ----------------- 
    ldi XL, ArrayL
    ldi XH, ArrayH

reset:
    
	; ----------------- CLEAR TIMER1 -----------------
	clr tmp  
	out TCNT1L,tmp
	out TCNT1H,tmp

    ; ----------------- INSTALL TIMER1 (PD6) -----------------
    clr tmp
    out TCCR1A,tmp 
    ldi tmp,1<<ICF1 ; clear input capture flag
    out TIFR,tmp ; clear input capture flag
    ldi tmp,0b01000001 ; capture positive pulse 
    out TCCR1B,tmp ; prescaler CK / 1

    ; ----------------- CLEAR INPUT CAPTURE COUNTER -----------------
    clr tmp
	out ICR1H, tmp
	out ICR1L, tmp
    
    ; ----------------- ENABLE INPUT CAPTURE INTERUPTS -----------------
    ldi tmp,1<<TICIE1
	out TIMSK,tmp

    ldi flag,0x05 ; set flag

    sei ; enable interupts
	
    
WAIT:
    ; ----------------- WAIT INTERUPTS -----------------
    cpi flag,0x00 ; if 5 interupts arrived 
    breq CALCULATE_RESULT ; calculate period
	rjmp WAIT ; else wait for interupts

INTERUPT:
    ; ----------------- INTERUPT APPEARED -----------------
    cli ; disable interupts
    cpi flag,5 ; if 1st interupt comes
    breq SAVE_FIRST_CAPTURE ; save result of input capture to registers
    cpi flag,1 ; if 4th interupt comes
    breq SAVE_FOURTH_CAPTURE ; save result of input capture to registers
    rjmp FINISH ; other interupts will not be saved
SAVE_FIRST_CAPTURE:
    in capture1L,ICR1L ; saving 1st capture
    in capture1H, ICR1H ; saving 1st capture
    rjmp FINISH
SAVE_FOURTH_CAPTURE:
    in capture2L,ICR1L ; saving 4th capture
    in capture2H,ICR1H ; saving 4th capture
FINISH:
    dec flag ; decrease capture flag
    sei ; enable interupts
    reti ; return interupt
    
CALCULATE_RESULT:

    cli ; disable interupts

    ; ----------------- CALCULATE AND SAVE RESULT -----------------
    sub capture2L,capture1L ; apply substract
    sbc capture2H,capture1H ; apply substract
    lsr capture2H ; right shift with carry
    lsr capture2L ; right shift with carry
    clc ; clear carry flag
    st X+, capture2L ; save current capture
    st X+, capture2H ; save current capture

	; --------------- START CONVERSION ADC -----------------

		ldi tmp,0b01100000 ; bits 7:6 used for ref voltage, bit 5 used to left justify, bit 4:0 enable adc0
		out ADMUX, tmp ; enable ADC0 
        ldi tmp, 0b11000000
		out ADCSRA,tmp ; start conversion

    ; --------------- CONVERSION IN PROGRESS ---------------

wait_convertsion:
        in tmp, ADCSRA
        andi tmp,0b00010000
        cpi tmp,0b00010000
        breq conversion_finished
        rjmp wait_convertsion
conversion_finished:

        ; ------ STORE RESULT OF ADC ---------------
        in tmp,ADCH 
        st X+,tmp  

CHOOSE_BUTTON:
    ; ----------------- PRESS SW7 TO MEASURE AGAIN -----------------
    sbis PIND,7
    rjmp MEASURE_NEXT
    ; ----------------- PRESS SW0 TO SHOW RESULTS -----------------
    sbis PIND,0
    rjmp LOAD_RESULT
    rjmp CHOOSE_BUTTON
	
MEASURE_NEXT:
    sbis PIND,7 ; wait to release sw7 
    rjmp MEASURE_NEXT ; do nothing until released
	rjmp reset ; measure again

LOAD_RESULT:
    sbic PIND,0 ; wait to release sw0
    rjmp SHOW_RESULT ; go to results
    rjmp LOAD_RESULT ; show results


SHOW_RESULT:
    ; ----------------- SET LEDS TO PORTA -----------------
	clr tmp
	out DDRA,tmp 
	out PORTA,tmp ; turn off leds
LOOP_RESULT:
    cpi XL,0 ; check if all results appeared
    breq end_game ; end of program
	ld ADCHIGH,-X ;pre decrement and load ADCH
	com ADCHIGH ; inverse 
    out PORTA,ADCHIGH ; show ADCH
	rcall sw0_click ; wait to click sw7 for high result
    ld resultH,-X ; pre decrement and load high result  
    com resultH ; inverse 
    out PORTA,resultH ; show high byte result
	rcall sw0_click ; wait to click sw7 for low result
   ; dec XL ; decrease remaining relults 
    ld resultL,-X ; pre decrement and load low result 
    com resultL ; inverse logic
    out PORTA,resultL ; show low byte result
	rcall sw0_click ; wait to click sw7 for high result  
    rjmp LOOP_RESULT 

; ----------------- FUNCTION IMPLEMENTS SW7 CLICK -----------------
sw0_click:
	sbic PIND,0
    rjmp sw0_click
sw0_release:
    sbis PIND,0
    rjmp sw0_release 
	ret
    
; ----------------- END OF APPLICATION -----------------
end_game:
