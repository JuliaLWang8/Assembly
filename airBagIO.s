.global _start
_start:
   // setup the stack pointers
   	MOV R1, #0b10010 //IRQ mode, disable inturrupts
	MSR CPSR, R1 //change to IRQ mode
	LDR SP, =0x200000 //stack ptr for irq mode
	
	MOV R1, #0b10011 //supervisor mode, disable inturrupts
	MSR CPSR, R1 //change mode
	LDR SP, =0x100000 //SVC stack pointer

   BL   CONFIG_GIC    // configure the ARM generic interrupt controller
	BL CONFIG_AB
	
	//Set I=0 in CPSR:
	MOV R0, #0b00010011 //SVC mode - enable interrupts 
	MSR CPSR, R0

CONFIG_AB:
	LDR R0, =0xFFFEC800
	MOV R1, #0b10000128 //I=0, threshold=128
	STR R1, [R0] //store into address 800
	MOV PC, LR

//setup IRQ handler
.global IRQ_HANDLER
IRQ_HANDLER:
    /* save R0-R3, because subroutines called from here might modify
       these registers without saving/restoring them. Save R4, R5
     because we modify them in this subroutine */
       PUSH  {R0-R5, LR}
    
       /* Read the ICCIAR from the CPU interface */
       LDR  R4, =MPCORE_GIC_CPUIF
       LDR  R5, [R4, #ICCIAR]    // read the interrupt ID

AIRBAG_CHECK:
       // write your code here to call the AIRBAG_ISR as appropriate
		CMP R5, #0x65 //101 in decimal
		BNE UNKNOWN_IRQ
		BL AIRBAG_ISR
		B EXIT_IRQ
UNKNOWN_IRQ: 
				B UNKNOWN_IRQ //INF LOOP
    
EXIT_IRQ:
       /* Write to the End of Interrupt Register (ICCEOIR) */
       STR  R5, [R4, #ICCEOIR]
    
       POP  {R0-R5, LR}
       SUBS  PC, LR, #4      // return from interrupt

//setup ISR
AIRBAG_ISR:
	LDR	R0, =0xFFFEC800		// base address for airbag
	LDR	R1, [R0, #0x4]		// read intensity
	STR	R1, [R0, #0x4]		//clear intensity by storing it back
	
	CHECKTHRESH:
		LDR R2, [R0]
		CMP R1, R2 //compare intensity (r1) to threshold (r2)
		BLT END_ISR //if less than the threshold, we don't do anything
		//if greater than thresh, deploy airbag
		LDR R3, =0xFFFEC900
		MOV R4, #0b1
		STR R4, [R3] //store 1 into the D bit
		B END_ISR
END_ISR:
	MOV PC, LR
