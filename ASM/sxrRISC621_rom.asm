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

@Start			MULC	R0,		0	 ;
				MULC	R1,		0	 ;
				MUL		R0,		R1	 ;
				CALL	@NegTestFail ;
				NOT		R1;
				ST		R1, M[0+0x0010];
				NOT 	R1;
				ADDC	R1,		5	 ;
				CPY		R5,		R1	 ;
				SWAP	R5,		RC	 ;	
				LD		R9, M[0+0x0010];
				JMP		@Start		 ;

@NegTestFail	SUB		R0,		R0	 ;
				ADDC	R0,		1	 ;
				JMPN	@Start		 ;
@NegTestPass	SUB		R0,		R0	 ;
				SUBC	R0,		1	 ;
				JMPN	@OverTestFail;

@ZeroTestFail	SUB		R0,		R0	 ;
				ADDC	R0,		1	 ;
				JMPZ	@Start		 ;
@ZeroTestPass	SUB		R0,		R0	 ;
				JMPZ	@CarTestFail;

@OverTestFail	SUB		R0,		R0	 	;
				ADDC	R0,		1	 	;
				JMPV	@Start		 	;
@OverTestPass	SUB		R0,		R0	 	;
				ADDC	R0,		15	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				JMPV	@ZeroTestFail 	;

@CarTestFail	SUB		R0,		R0	 	;
				ADDC	R0,		1	 	;
				JMPC	@Start		 	;
@CarTestPass	SUB		R0,		R0	 	;
				NOT		R0;
				ADDC	R0,		1	 	;
				JMPC	@NCarTestFail 	;

@NNegTestFail	SUB		R0,		R0	 	;
				SUBC	R0,		1	 	;
				JMPNN	@Start		 	;
@NNegTestPass	SUB		R0,		R0	 	;
				ADDC	R0,		1	 	;
				JMPNN	@NOverTestFail	;

@NZeroTestFail	SUB		R0,		R0	 	;
				JMPNZ	@Start		 	;
@NZeroTestPass	SUB		R0,		R0	 	;
				SUBC	R0,		1	 	;
				JMPNZ	@ReturnTest  	;

@NOverTestFail	SUB		R0,		R0	 	;
				ADDC	R0,		15	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				ADD		R0,		R0 	 	;
				JMPNV	@Start		 	;
@NOverTestPass	SUB		R0,		R0	 	;
				SUBC	R0,		1	 	;
				JMPNV	@NZeroTestFail	;

@NCarTestFail	SUB		R0,		R0	 	;
				NOT		R0;
				ADDC	R0,		1	 	;
				JMPNC	@Start		 	;
@NCarTestPass	SUB		R0,		R0	 	;
				ADDC	R0,		1	 	;
				JMPNC	@NNegTestFail	;

@ReturnTest		RET;

.endcode