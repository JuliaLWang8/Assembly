//.text
//.global _start
//_start:
ONES:
	LDR R2, =TEST_NUM
	LDR R1, [R2] //R1 holds value of the number
	MOV R0, #0 //R0 is 0
LOOP:
	CMP R1, #0 //if the number = 0, end
	BEQ ENDSUB
	LSR R2, R1, #1 //R2 = R1 shifted left 1 
	AND R1, R1, R2 //R1 = R1 & R2
	ADD R0, #1 //R0 = R0 + 1 (consecutive 1s!)
	B LOOP
ENDSUB:
	MOV PC, LR
//END:
//	B END

//TEST_NUM: .word 0x103fe00f
//.end 
	