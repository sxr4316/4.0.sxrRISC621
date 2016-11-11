;------------------------------------------------------------------------------
;	Assembler directives:
;------------------------------------------------------------------------------

.directives;
;
.enddirectives;

;------------------------------------------------------------------------------
;	Constant segment:
;------------------------------------------------------------------------------

.constants;
;
.endconstants;

;------------------------------------------------------------------------------
;	Code segment:
;------------------------------------------------------------------------------

.code;
			LD		RE, M[0+0x0001]; % Load the Case Change Offset %

			LD		RF, M[0+0x0000]; % Load Loop Counter to 64 %

			SUB	R7, R7; % Reset Register R7 %

@Start	LD		R0, M[R7+0x0010];
			ST		R0, M[R7+0x0500];
			ADDC	R7, 1;
			LD		R0, M[R7+0x0010];
			ST		R0, M[R7+0x0600];
			ADDC	R7, 1;
			LD		R0, M[R7+0x0010];
			ST		R0, M[R7+0x0700];
			ADDC	R7, 1;
			LD		R0, M[R7+0x0010];
			ST		R0, M[R7+0x0800];
			ADDC	R7, 1;
			SUBC	RF, 1;
			JMPNZ	@Start;

			LD		RF, M[0+0x0000]; % Load Loop Counter to 64 %
			SUB 	R7, R7;
			
@Upper	LD		R0, M[R7+0x0500];
			ADDV	R0, RE;
			ST		R0, M[R7+0x0A00];
			ADDC	R7, 1;
			SUBC	RF, 1;
			JMPNZ	@Upper;

			LD		RF, M[0+0x0000]; % Load Loop Counter to 64 %
			SUB 	R7, R7;
			
@Lower	LD		R0, M[R7+0x0600];
			SUBV	R0, RE;
			ST		R0, M[R7+0x0B00];
			ADDC	R7, 1;
			SUBC	RF, 1;
			JMPNZ	@Lower;
			
			
.endcode