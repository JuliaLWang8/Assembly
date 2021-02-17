.global _start
_start:
	LDR R0, =0xCE201000 //base address of the device
	LDR R1, =CONVERTED_DATA
	MOV R3, #0b100 //setting I=0
	STR R3, [R0]
LOOP:
	LDR R2, [R0] //value at the base address
	LDR R3, =0x00000038 //bit mask
	AND R4, R3, R2 //contains just the 3 bits
	LSR R4, #3 //shift 3 bits, now we have the channel select
	MOV R5, #0b1000
	CMP R4, R5 //if it is 8, we change it back to 0
	BEQ RESETCHANNEL
	//otherwise, 
	ADD R4, R4, #1 //add 1 to change channel
	MOV R3, #0b101 //go = 1
	STR R3, [R0] //store into the device to go!
	B FINISHLOOP
RESETCHANNEL:
	LDR R3, =0x00000007 //bit mask
	AND R4, R3, R2 //r4 is just the bottom 3 I D Go
	STR R4, [R0] //store back into the device
	LDR R1, =CONVERTED_DATA //reset r1 back to beginning
FINISHLOOP:
	WAIT: //wait until D=1 for conversion to finish
		LDR R3, [R0] 
		AND R3, R3, #0x00000002 //since 2 = 0010, means D bit is 1
		CMP R3, #0x00000002
		BNE WAIT //if done is not 1
		// we are done, lets store into Converted data
		LDR R4, [R0, #4] //R4 top 11 bits is the converted data
		LSL R4, #11 //now the bottom 11 bits is the converted data
		STRH R4, [R1] //store half word into the array
		ADD R1, R1, #2 //increment array
	B LOOP
END:
	B END
    .data
CONVERTED_DATA: .hword 0, 0, 0, 0, 0, 0, 0, 0