.global _start
_start:
	//R5 is the led sequence
	LDR R1, = 0xFF200000 //LEDs
	LDR R2, = 0xFF200050 //KEYS
	LDR R3, = 0xFFFEC600 //TIMER
	LDR R0, =49999999 //200MHz, every 0.25 seconds must be 50E6 cycles
	
	//store 50E6 into timer
	STR R0, [R3]
	//set up EA
	MOV R4, #0b011 //R4 is the E (enables counting) and A (autoreload)
	STR R4, [R3, #8] //E and A are 8 from timer
	MOV R6, #0
	//initial value
	LDR R5, =LIST
	LDR R6, [R5]
	MOV R8, #0

LOOP:
	STR R6, [R1]
	CMP R8, #1
	BEQ KEYPRESS1
KEYCHECK:
	//check key
	LDR R4, [R2]
	CMP R4, #0x00000008 //KEY3 is pressed?
	BEQ KEYPRESS1
	B WAIT
WAIT:
	//check f bit
	LDR R7, [R3, #0xC]
	CMP R7, #0
	BEQ WAIT
	STR R7, [R3, #0xC]
	ADD R5, R5, #4 //increment R5 (list element)
	LDR R6, [R5] //R6= the value at address R5
	//handle list resetting at the last element
	LDR R7, =LIST
	ADD R7, #32
	CMP R7, R5//if r5 == 0b0100000010
	BEQ RESETLOOP//reset r5 to LIST
	//else add 4 to r5 each time
	B LOOP
END:
	B END

RESETLOOP:
	LDR R5, =LIST
	LDR R6, [R5]
	B LOOP

KEYPRESS1: //check if released, if so stop
	LDR R4, [R2] //read keys
	CMP R4, #0 //if key unpressed
	BEQ UNPRESS1
	//if key is still pressed
	MOV R8, #1
	B WAIT //if not released, continue check again until released

UNPRESS1: //second turn
	LDR R4, [R2] //read keys
	CMP R4, #8 //if key pressed
	BEQ KEYPRESS2
	MOV R8, #0
	//if still unpressed
	B UNPRESS1
KEYPRESS2:
	//pressed twice? restart
	LDR R4, [R2] //read keys
	CMP R4, #0 //if key unpressed
	BEQ WAIT
	//if key is pressed
	B KEYPRESS2

LIST: .word 0x201, 0x102, 0x84, 0x48, 0x30, 0x48, 0x84, 0x102

.end