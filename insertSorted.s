//wrote a subroutine which takes in a sorted list LIST
//subroutine takes in an element we want to insert R2
//and the length of the list R1 
//inserts the element into the correct spot in the list

.global _start
_start:
	LDR SP, =0x1000000
	LDR R0, =LIST//Load the list of nubers
	MOV R2, #6 //value I want to add
	MOV R1, #4	//length of list - 1
	BL INSERTT
	B END
INSERTT:
	PUSH {R1, R3, LR}
LOOP:
	MOV R3, #0
	LSL R3, R1, #2 //n*4
	PUSH {R4, R5, R6}
	ADD R4, R0, R3 
	LDR R5, [R0, R3] //r4 is the value of the current element
	CMP R2, R5
	BGT INSERT //insert if greater than current element, otherwise shift
	ADD R6, R4, #4 //r6 address 1 word above current
	STR R5, [R6] //store word there
	POP {R4, R5, R6}
	B FINISHLOOP
INSERT: //in address above current
	ADD R4, R4, #4 
	STR R2, [R4]
	POP {R4, R5, R6}
	B ENDSUB
FINISHLOOP:
	SUB R1, R1, #1
	B LOOP
ENDSUB:
	POP {R1, R3, PC}
END: B END

LIST:
	.word 1,2,3,7,9,0xFFFFFFFF