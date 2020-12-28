.global _start
_start:

//configure interrupt
CONFIG_AD:
	//initial setup in _start
	MOV R0, #0xFF200200 	//irq device address
	MOV R1, #0x00867f00 //mask
	STR R1, [r0, #8] //interrupt thresholds (mask in keys) at address r0+8
	
	MOV R0, #0b01010011 //SVC mode - enable interrupts
	MSR CPSR, R0
	MOV PC, LR

//IRQ handler
SERVICE_IRQ:
	PUSH {r0-r5, LR}
	LDR		R4, =MPCORE_GIC_CPUIF
    LDR		R5, [R4, #ICCIAR] 
	
	CHECK:
		CMP R5, #91 //IRQ id
		BNE UNKNOWN
		BL ADC_ISR
		B EXIT_IRQ
	UNKNOWN:
		B UNKNOWN
	EXIT_IRQ:
			STR		R5, [R4, #ICCEOIR]
			POP		{R0-R5, LR}
			SUBS		PC, LR, #4	

//int service routine
ADC_ISR:
	PUSH{r0-r11}
	LDR R0, =0xFF200200 //load base address
	LDR	R1, [R0, #0xC]		// read interupt status register 
	STR	R1, [R0, #0xC]		
	
	CHECK1: //checking if channel 1 interrupt is called
		MOV R3, #0x0000ff00
		AND R4, R3, [r0, #8]
		CMP R4, #0
		BEQ CHECK2
		B DECREMENT1
	DECREMENT1: //decremend threshold 1
		LDR R2, [R0, #8] //entire threshold interrupts
		SUB R2, R2, #0x00000100 //subtracted 1 from threshold
		STR R2, [R0, #8] //stored threshold back into it
		B END_ISR
	CHECK2:
		MOV R3, #0x00ff0000
		AND R4, R3, [r0, #8]
		CMP R4, #0
		BEQ END_ISR
		B DECREMENT2
	DECREMENT2:
		LDR R2, [R0, #8] //entire threshold interrupts
		SUB R2, R2, #0x00010000 //subtracted 1 from threshold
		STR R2, [R0, #8] //stored threshold back into it
		B END_ISR
END_ISR:
	POP {r0-r11}
	MOV PC, LR
	