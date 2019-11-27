;** File Name:          b1.asm
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
.def temp = r16       ; temporary variable for general use
.def flag = r17      ; counter used to capture 5 interrupts
.def curr_pwm = r18   ; register to store analog to digital result
.def temp2 = r30
.def t2Mode = r31
.def t2StepCounter = r29
; ----------------- DEFINE SAVE ADDRESS -----------------
.equ ArrayH = 0x01 
.equ ArrayL = 0x00
.equ pwm_step = 12
.equ INCREASE_STEP = 5
.equ TEN_SEC_CHECK = 100 ;TODO
; ----------------- INTERUPT VECTOR ADDRESSES -----------------
.org 0x0000
	rjmp reset
.org 0x000A
	rjmp INTERUPT
; TODO interrupt for timer2
.org 0x000F
    rjmp timer2INT

reset:
	ldi XL, ArrayL
	ldi XH, ArrayH
    ; initialize() stack pointer
    ldi temp, low(RAMEND)
    out SPL,temp
    ldi temp,high(RAMEND)
    out SPH,temp

    ;----------- init PWM -----------
    ldi temp, 0b00001000 ;set pb3 as output
    out DDRB, temp
    ldi temp, 0b01100011 ; wgm00, com01, cs0-1/0
    out TCCR0, temp

    ; load 20% pwm as init val
    ldi curr_pwm, 55
    out OCR0, curr_pwm

    ;---------- Set buttons to pd0,1 --------
    ldi temp, 0b00000000 ; the whole ddrd is input
    out DDRD, temp


    ;ldi t2Counter, 0
    ldi t2Mode, 1           ; mode 1 -> increase, mode 2 -> stay for 10 sec, mode 3 decrease
    ldi t2StepCounter, 0
    ;--------- Set PORT A as leds
    ; TODO


speed_handler:
    ; skip if bit is set
    ; TODO REMOVE ALL
    sbis PIND, 0 ; sw0 speed up
    rjmp inc_speed
    sbis PIND, 1 ; sw1 slow down
    rjmp dec_speed
    sbis PIND, 2 ; show results
	rjmp SHOW_RESULT
    rjmp speed_handler

inc_speed:
    ; wait user to release
    sbis PIND, 0 
    rjmp inc_speed
    rcall measuring_loop
    ldi temp, pwm_step
    add curr_pwm, temp
    out OCR0,curr_pwm
    rjmp speed_handler
    ; 

dec_speed:
    sbis PIND, 1 
    rjmp dec_speed
    rcall measuring_loop
    cpi curr_pwm, pwm_step
    brlo zeroing_speed
    subi curr_pwm, pwm_step
    out OCR0,curr_pwm
    rjmp speed_handler

zeroing_speed: 
    ldi curr_pwm, 0x00
    out OCR0,curr_pwm
    rjmp speed_handler

measuring_loop:
    clr temp  
	out TCNT1L,temp
	out TCNT1H,temp
     ; ----------------- INSTALL TIMER1 (PD6) -----------------
    clr temp
    out TCCR1A,temp 
    ldi temp,1<<ICF1 ; clear input capture flag
    out TIFR,temp ; clear input capture flag
    ldi temp,0b01000001 ; capture positive pulse 
    out TCCR1B,temp ; prescaler CK / 1

    ; ----------------- CLEAR INPUT CAPTURE COUNTER -----------------
    clr temp
	out ICR1H, temp
	out ICR1L, temp
    
    ; ----------------- ENABLE INPUT CAPTURE INTERUPTS -----------------
    ldi temp,1<<TICIE1
	out TIMSK,temp

    ldi flag,0x05 ; set flag

    sei ; enable interupts
m_loop:
	

loop:
    cpi flag, 0x00
    breq CALCULATE_RESULT
    rjmp loop

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
    ret


INTERUPT:
    ; ----------------- INTERUPT APPEARED -----------------
    cli ; disable interupts
    in temp2, TIMSK
    ldi temp, 1<<TICIE1
    com temp
    and temp, temp2
    out TIMSK
    sei
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


; TODO implement timer2 interrupt
timer2INT: 
    ;inc t2Counter
    cpi t2Mode, 1
    breq MODE_1             ;increase 
    cpi t2Mode, 2 
    breq MODE_2             ;decrease
    cpi t2Mode, 3
    breq MODE_3             ;stay

    rjmp timer2INT


    
MODE_1:
    inc t2StepCounter
    cpi t2StepCounter, INCREASE_STEP       ; if stepCounter == INC_STEP => increase PWM
    breq MODE_1_CONT
    reti

MODE_1_CONT:
; wait user to release
    ldi t2StepCounter, 0
    rcall measuring_loop
    ldi temp, pwm_step
    add curr_pwm, temp
    out OCR0,curr_pwm
    ;rjmp MODE_CHECK
    ldi t2Mode, 3
    reti

MODE_2:
    inc t2StepCounter
    cpi t2StepCounter, INCREASE_STEP       ; if stepCounter == INC_STEP => increase PWM
    breq MODE_2_CONT
    reti

MODE_2_CONT:
    ldi t2StepCounter, 0
    rcall measuring_loop
    cpi curr_pwm, pwm_step
    brlo zeroing_speed_2
    subi curr_pwm, pwm_step
    out OCR0,curr_pwm
    ;rjmp MODE_CHECK
    ldi t2Mode, 1
    reti
zeroing_speed_2: 
    ldi curr_pwm, 0x00
    out OCR0,curr_pwm
    ;rjmp MODE_CHECK
    reti

MODE_3:
    inc t2StepCounter
    cpi t2StepCounter, TEN_SEC_CHECK
    brge MODE_3_CONT
    reti
MODE_3_CONT:
    ldi t2StepCounter, 0
    ldi t2Mode, 2
    reti






SHOW_RESULT:
    sbis PIND, 2
    rjmp SHOW_RESULT
    ; ----------------- SET LEDS TO PORTA -----------------
	ser temp
	out DDRA,temp 
	out PORTA,temp ; turn off leds
LOOP_RESULT:
    cpi XL,0 ; check if all results appeared
    breq end_game ; end of programDDRA 7 26
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
	sbic PIND,2
    rjmp sw0_click
sw0_release:
    sbis PIND,2
    rjmp sw0_release 
	ret
    
; ----------------- END OF APPLICATION -----------------
end_game:
