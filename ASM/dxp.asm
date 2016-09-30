; 	dxp's first assembly test program.
;------------------------------------------------------------------------------
;	Assembler directives:
;------------------------------------------------------------------------------
;
;
;
	.directives;
	;
	.equ	constOne	0x1;
	.equ	constTwo	0x2;
	;
	.enddirectives;
;------------------------------------------------------------------------------
;	Constant segment:
;------------------------------------------------------------------------------
; These values are initialized in the locations at the end of the code segment.
; For now, .word is the only constant initialization assembly directive.
; After assembling the code, during the final run, the constant name is 
;   replaced with its location address in the program memory.
	.constants;
;
	.word	firstConstWord	0xFFFF;
	;
	.endconstants;
;------------------------------------------------------------------------------
;	Code segment:
;------------------------------------------------------------------------------
	.code;
			ADDC	R5, 0x2;
			SUBC	R6, 0x2;
			ADD		R6, R5;
			SUB		R5, R6;

               RET ;
			SHLA	R5, R2;
			NOT R0;
			ADDC	R6, 0x3;
			CPY		R7, R5;
			MUL		R7, R6;
			SWAP	R7, R5;
; The ROTR is the fix to my original code:
			ROTR	R5, R3;
			DIV		R7, R5;
			CPY		R8, R7;
			XOR		R8, R5;
			RTRC	R5, R2;
			JMPC	@jmp_here;
@jmp_here	ST		R5, M[R0, 0x0555];
			RTLC	R5 R5;
			LD		R5, M[R0, 0x0555];
			OUT		R5, SP;
			IN		R8, SP;
	.endcode;
