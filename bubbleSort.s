.text
.global _start
_start:
	LDR R6,=LIST //R6 = address of first list elem
	LDR R10,[R6] //R10 = i
	CMP R10,#1 
	BLE END		//end if the list has only 1 element
	
LOOPN: 
	MOV R8,#0	//placeholder for swap
	MOV R9,#1	//R9 = j
	ADD R5,R6,#4	//r5 = the address of next

LOOPJ:
	CMP R10,R9 //compare i with j
	BEQ DONEJ //if i - j, we're done with j, move onto the next i
	MOV R0,R5
	BL SWAP

	ORR R8,R8,R0	//store the flag of the element if swapped

	ADD R9,R9,#1	//j++
	ADD R5,R5,#4	//load the address of the next element
	B LOOPJ

DONEJ:
	SUB R10,R10,#1 //move onto the next i
	CMP R8,#0 //compare if 
	BEQ END
	
	LDR R1,=LIST	//reload
	B LOOPN
	
END:
	B END

//SWAP
//R0 has the address of the next element as the input
//return R0 = 1 if swap happened or R0 = 0 if nothing happend
SWAP:
	MOV R1,R0 //R6 = address of p
	MOV R0,#0 //reset R0
	LDR R2,[R1] //R2 = value at p
	LDR R3,[R1,#4] //R3 = value at p+1
	CMP R2,R3 
	BLT RETURN //if p < p+1, skip swap
	//swap
	MOV R0,#1 //set r0 to swapped
	STR R3,[R1] //R6 (address of p) gets R3 (value at p+1)
	STR R2,[R1,#4] //R6 + 4 gets R2 (value at p)
	RETURN:
		MOV PC,LR //go back to code after swap is over
//LIST: .word 10,0x1400,0x45,0x23,0x5,0x3,0x8,0x17,0x4,0x20,0x33
.end
