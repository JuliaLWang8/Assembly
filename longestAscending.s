.data
LIST:
  .word 2,1,4,6,8,7
N:
  .word 6

.text
.global _start
_start:
	LDR R3, =LIST//position in list is R3
	LDR R5, =N
	LDR R5, [R5] //R5 starts at N and decreases each time
	LDR R1, [R3] //first value
	ADD R3, R3, #4 //second value
	MOV R4, #0 //current total
LOOP:
	//loop
	LDR R2, [R3] //set current value to R2
	CMP R2, R1//check if greater than the previous, store previous in R1
	BGT GREATER
	MOV R4, #0// if not greater, reset r4 to 0
CONTINUE:
	// set current value to R1 (previous)
	MOV R2, R1
	SUB R5, R5, #1 //n-1
	CMP R5, #0
	BEQ END
	ADD R3, R3, #4//increment to next element R3 + 4
	B LOOP
GREATER: 
	ADD R4, R4, #1//if greater, we add 1 to our current count in R4 
	CMP R4, R0//compare current count to R0, if current count is greater, replace! 
	BLE CONTINUE
	MOV R4, R0 //copy r4 to r0 if its greater
	B CONTINUE
END:
	B END
