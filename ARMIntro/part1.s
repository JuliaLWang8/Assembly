.text
.global _start
_start:
	LDR R1, =TEST_NUM //r1 <- address of first element
	LDR R2, [R1] //R2 is the value of the first element
	MOV R8, #0 //R8 is 0
	MOV R7, #0 //R9 is 0
	
  	LOOP:
		CMP R2, #-1 //if R2 equal to this, end
		BEQ END
	//check if positive, count in R8
		CMP R2, #0 //if R2 is greater than 0, branch
		BGT GREATER
	//add to sum in R7
		ADD R7, R7, R2
	//set up for next cycle
		ADD R1, R1, #4 //R1 address of next word
		LDR R2, [R1] //R2 value at R1
		B LOOP
	
	GREATER:
		ADD R8, R8, #1 //count 1 more positive
			//add to sum in R7
		ADD R7, R7, R2
	//set up for next cycle
		ADD R1, R1, #4 //R1 address of next word
		LDR R2, [R1] //R2 value at R1
		B LOOP

END:
	B END

//TEST_NUM: .word 9, -4, 3, -5, 0xA, -1
	.end
