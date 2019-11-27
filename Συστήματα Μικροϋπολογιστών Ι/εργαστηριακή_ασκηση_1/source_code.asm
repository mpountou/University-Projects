;** File Name:          Lab01_8941_8872.asm
;** Group/Team:         5/2
;** Name1/AEM1          Ioannis Mpountouridis 8872
;** Name2/AEM2          Konstantinos Chatziantoniou 8941
;** Description:
;**** Section1:
;************* exc1     Store AEMs in Program Memory
;************* exc2     Open LEDs based on AEMs inequality
;************* exc3     Open LEDs based on if particular digits
;                           are odd or even.
;**** Section2:         Open LEDs based on key pressed

.include "m16def.inc"

.def digit_aem1 = r16
.def digit_aem2 = r17
.def temp1 = r18
.def temp2 = r19
.def temp3 = r20
.def largeraem = r21
.def arg = r22
.def loop1 = r23
.def loop2 = r24
.def loop3 = r25

.equ ZEROASCII = 0x30

.CSEG 

    AEM1: .db "8872"
    AEM2: .db "8941"


RESET:
    LDI	R16, low(RAMEND)				;** init stack pointer
	OUT	SPL, R16						;****
	LDI	R16, high(RAMEND)				;****
	OUT	SPH, R16						;****
	ser temp1							;** init port
	out DDRB,temp1						;**

MAIN: 
    ldi ZH , high(AEM1<<1)              ;** Load AEM addresses to Z and Y
    ldi ZL , low(AEM1<<1)               ;****
    ldi YH , high(AEM2<<1)              ;****
    ldi YL , low(AEM2<<1)               ;****
    ldi temp1 , 0x05                    ;** init counter for loop (FUN_COMPARE)
    rcall FUN_COMPARE                   ;** Call function FUN_COMPARE 
    rcall FUN_EXC2                      ;** Call function FUN_EXC2
    rjmp MAIN2


FUN_COMPARE:                            ;-------fun ** compare digits to find which AEM is greater-------
    dec temp1                           ;** decrease loop counter
    cpi temp1 , 0x0                     ;** check if it is zero to end loop
    breq FAIL                           ;** exit with FAIL when counter reaches zero
    lpm digit_aem1 , Z+                 ;** load AEM1 and increase index for the next iter
    movw X , Z                          ;** save AEM1 index
    movw Z , Y                          ;** load AEM2 address to Z
    lpm digit_aem2 , Z+                 ;** load AEM2 and increase index for the next iter
	MOVW Y,Z                            ;** save AEM2 index
	MOVW Z,X                            ;** load AEM1 address to Z
    cp digit_aem1 , digit_aem2          ;** compare the digits (MSB->LSB)
    brlo SUCCESS                        ;** go to SUCCESS if aem1 < aem2
    breq FUN_COMPARE                    ;** repeat if digits are equal
    brge FAIL                           ;** go to fail if AEM1 > AEM2

FAIL:                                   ;-------fun ** set largeraem reg and return to main--------------
    ldi largeraem , 0x01                ;** set largeraem reg/flag to know which AEM is larger
    ret                                 ;** return to main

SUCCESS:
    ldi largeraem , 0x02                ;** set largeraem reg/flag to know which AEM is larger
    ldi ZH , high(AEM1<<1)              ;** load address of AEM1 to Z
    ldi ZL , low(AEM1<<1)               ;****
    adiw Z , 0x02                       ;** add +2 to get 3rd number
    lpm digit_aem1 , Z+                 ;** load AEM1 3rd digit to reg
    subi digit_aem1 , ZEROASCII         ;** convert from ASCII to int
    lsl digit_aem1	                    ;** shift 4 times to put it in 4-7 leds
	lsl digit_aem1	                    ;****
	lsl digit_aem1	                    ;****
	lsl digit_aem1	                    ;****
    lpm digit_aem2 , Z                  ;** load 4th digit of AEM1 to digit_aem2 reg
    subi digit_aem2 , ZEROASCII         ;** convert from ASCII to int
    add digit_aem1 , digit_aem2         ;** put the output from LED together
    out portb , digit_aem1              ;** set I/O for leds
    rcall PAUSE_LOOP                    ;** go to loop for results to be visible
    ret                                 ;** return to main

FUN_EXC2:
    ldi YH , high(AEM1<<1)			    ;** load AEM1 address to Y
	ldi YL , low(AEM1<<1)	            ;****
	ldi ZH , high(AEM2<<1)			    ;** load AEM2 address to Z
	ldi ZL , low(AEM2<<1)               ;****
	adiw Z , 0x03                       ;** inc index for fourth digit
	adiw Y , 0x03                       ;** inc index for fourth digit
	lpm digit_aem2 , Z                  ;** load digit 
	subi digit_aem2 , ZEROASCII          ;** convert from ASCII to int
	movw Z,Y                            ;** load AEM1 address to Z
	lpm digit_aem1 , Z                  ;** load digit
	subi digit_aem1 , ZEROASCII          ;** convert from ASCII to int
	mov arg , digit_aem1                ;** set argument for function (FUN_ODDEVEN)
	rcall FUN_ODDEVEN                   ;** call function
	mov digit_aem1 , arg                ;** get result (0 for odd , 1 for even)
	mov arg , digit_aem2                ;** set argument for function (FUN_ODDEVEN)
	rcall FUN_ODDEVEN                   ;** call function
	mov digit_aem2 , arg                ;** get result
	ldi temp1,0x01    
	mov arg,digit_aem2;					;** prepare arg for possible function call
	cpse largeraem , temp1              ;** if AEM1 is larger skip shift for aem2
	rcall HELPER_EXC_2                  ;**	inverse and shift aem2
	mov digit_aem2 , arg				;** get result from possible f call
	ldi temp1 , 0x02                    
	mov arg , digit_aem1				;** prepare arg for possible function call
	cpse largeraem , temp1              ;** if AEM2 is larger skip shift for aem1
	rcall HELPER_EXC_2                  ;** shift aem1
	mov digit_aem1 , arg				;** get result from possible f call
	add digit_aem1 , digit_aem2         ;** put output together
	out portb , digit_aem1              ;** set I/O for leds
    ret                                 ;** return to main

FUN_ODDEVEN:
	cpi arg , 0x00
	breq EVENSUCCESS
	cpi arg , 0x01
	breq ODDSUCCESS
	subi arg , 0x02
	rjmp FUN_ODDEVEN
EVENSUCCESS:
	ldi arg, 0x00
	ret
ODDSUCCESS: 
	ldi arg, 0x01
	ret
HELPER_EXC_2:
	ldi temp1 , 0xff
	eor arg , temp1
	andi arg , 0x01
	lsl arg
	ret



MAIN2:                                  ;** label for section 2 of lab
	ldi temp1 , 0xFF                    ;** reset temp1
	sbic PIND , 0x0                     ;** skip if sw0 is not pressed
	rjmp RELEASE_LOOP_0                 ;** go to label to wait for sw0 release
	sbic PIND , 0x01                    ;** skip if sw1 is not pressed
	rjmp RELEASE_LOOP_1                 ;** go to label to wait for sw1 release
	sbic PIND , 0x02                    ;** skip if sw2 is not pressed
	rjmp RELEASE_LOOP_2                 ;** go to label to wait for sw2 release
	sbic PIND , 0x03                    ;** skip if sw3 is not pressed
	rjmp RELEASE_LOOP_3                 ;** go to label to wait for sw3 release
	sbic PIND , 0x07                    ;** skip if sw7 is not pressed
	rjmp RELEASE_LOOP_7                 ;** go to label to wait for sw7 release
	rjmp MAIN2                          ;** repeat to wait for input

;***** SW0 btn	
RELEASE_LOOP_0:
	sbis PIND ,0x0                      ;** skip call if still pressed
	rjmp DO_BTN_0                       ;** do stuff when released
	rjmp RELEASE_LOOP_0                 ;** repeat to wait release


DO_BTN_0:   
	ldi ZH , high(AEM1<<1)              ;** load AEM1 address to Z
	ldi ZL , low(AEM1<<1)               ;****
	ldi YH , high(AEM2<<1)              ;** load AEM2 address to Y
	ldi YL , low(AEM2<<1)               ;****
	ldi temp1 , 0x01
	cpse largeraem , temp1              ;** if aem1 is larger skip and keep it in Z
	movw Z , Y                          ;** move aem2 address from Y to Z
	adiw Z , 0x02                       ;** inc index for 3rd num
	lpm temp1 , Z+                      ;** load num to reg
	subi temp1 , ZEROASCII              ;** convert from ASCII to int
	lpm temp2 , Z                       ;** load 4th num to reg
	subi temp2 , ZEROASCII              ;** conver from ASCII to int
	lsl temp1                           ;** shift four times to put in leds4-7
	lsl temp1                           ;****
	lsl temp1                           ;****
	lsl temp1                           ;****
	add temp1,temp2                     ;** put numbers together for output
	out PORTB , temp1                   ;** set I/O for leds
	rcall PAUSE_LOOP                    ;** pause for the result to appear
	rjmp MAIN2                          ;** back to main to read btn input

;***** SW1 btn
RELEASE_LOOP_1:
	sbis PIND ,0x01
	rjmp DO_BTN_1
	rjmp RELEASE_LOOP_1


DO_BTN_1:
	ldi ZH , high(AEM1<<1)
	ldi ZL , low(AEM1<<1)
	ldi YH , high(AEM2<<1)
	ldi YL , low(AEM2<<1)
	ldi temp1 , 0x01
	cpse largeraem , temp1
	movw Z , Y
	lpm temp1 , Z+
	subi temp1 , ZEROASCII
	lpm temp2 , Z
	subi temp2 , ZEROASCII
	lsl temp1
	lsl temp1
	lsl temp1
	lsl temp1 ;**x4
	add temp1,temp2
	out PORTB , temp1
	rcall PAUSE_LOOP
	rjmp MAIN2

;***** SW2 btn
RELEASE_LOOP_2:
	sbis PIND ,0x02
	rjmp DO_BTN_2
	rjmp RELEASE_LOOP_2


DO_BTN_2:
	ldi ZH , high(AEM1<<1)
	ldi ZL , low(AEM1<<1)
	ldi YH , high(AEM2<<1)
	ldi YL , low(AEM2<<1)
	ldi temp2 , 0x02
	cpse largeraem , temp2
	movw Z , Y
	adiw Z , 0x02
	lpm temp1 , Z+
	subi temp1 , ZEROASCII
	lpm temp2 , Z
	subi temp2 , ZEROASCII
	lsl temp1
	lsl temp1
	lsl temp1
	lsl temp1 ;**x4
	add temp1,temp2
	out PORTB , temp1
	rcall PAUSE_LOOP
	rjmp MAIN2

;***** SW3 btn
RELEASE_LOOP_3:
	sbis PIND ,0x03
	rjmp DO_BTN_3
	rjmp RELEASE_LOOP_3


DO_BTN_3:
	ldi ZH , high(AEM1<<1)
	ldi ZL , low(AEM1<<1)
	ldi YH , high(AEM2<<1)
	ldi YL , low(AEM2<<1)
	ldi temp1 , 0x02
	cpse largeraem , temp1
	movw Z , Y
	lpm temp1 , Z+
	subi temp1 , ZEROASCII
	lpm temp2 , Z
	subi temp2 , ZEROASCII
	lsl temp1
	lsl temp1
	lsl temp1
	lsl temp1 ;**x4
	add temp1,temp2
	out PORTB , temp1
	rcall PAUSE_LOOP
	rjmp MAIN2


;***** SW7 btn
RELEASE_LOOP_7:
	sbis PIND ,0x07
	rjmp DO_BTN_7
	rjmp RELEASE_LOOP_7


DO_BTN_7:
	rcall FUN_EXC2
	rcall PAUSE_LOOP
	rjmp MAIN2


PAUSE_LOOP:
	ldi loop1 ,1
	ldi loop2 , 2
	ldi loop3 , 3
	rjmp L1

L1:
	dec  loop3
    brne L1
    dec  loop2
    brne L1
    dec  loop1
    brne L1
    ret 
