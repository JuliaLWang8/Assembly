.text
.global _start
_start:
	LDR R0, =NUMBERS
	LDR R1, =N
	LDR R1, [R1] 
	MOV R2, #0
	MOV R3, #0 
LOOP:
	STR R2, NEGNUM
	CMP R3, R1
	BEQ END
	LDR R4, [R0]
	CMP R4, #0
	BGE NOTNEG
	ADD R2, R2, #1
	ADD R0, R0, #4
	ADD R3, R3, #1
	B LOOP 
NOTNEG:
	ADD R3, R3, #1
	ADD R0, R0, #4
	B LOOP
END:
	B END
	
NUMBERS: 
	.word 2, -5, 3, -6, -10, 11, -3
N:
	.word 7
NEGNUM: .word 0
.end