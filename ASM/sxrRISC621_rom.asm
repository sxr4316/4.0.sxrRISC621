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
	ADDC R0, 1;
	ADDC R1, 2;
	ADDC R2, 3;
	ADDC R3, 4;
	ADDC R0, 1;
	ADDC R1, 2;
	ADDC R2, 3;
	ADDC R3, 4;
	ADDC R0, 1;
	ADDC R1, 2;
@Label	ST   R2, M[R8 + 0x001];
	ADDC R2, 3;
	ADDC R3, 4;
	ADDC R0, 1;
	ADDC R1, 2;
	ADDC R2, 3;
	ADDC R3, 4;
	ADDC R0, 1;
	ADDC R1, 2;
	LD   R2, M[R8 + 0x001];
	ADDC R2, 3;
	ADDC R3, 4;
	ADDC R0, 1;
	ADDC R0, 1;
	ADDC R0, 1;
	ADDC R0, 1;
	JMP  @Label;
	ADDC R0, 1;
	ADDC R0, 1;
	ADDC R0, 1;
	SUBC R0, 1;
	SUBC R1, 2;
	SUBC R2, 3;
	SUBC R3, 4;
	SUBC R0, 1;
	SUBC R1, 2;
	SUBC R2, 3;
	SUBC R3, 4;
	SUBC R0, 1;
	SUBC R1, 2;
	SUBC R2, 3;
	SUBC R3, 4;
	SUBC R0, 1;
	SUBC R1, 2;
	SUBC R2, 3;
	SUBC R3, 4;
	SUBC R0, 1;
	SUBC R1, 2;
	SUBC R2, 3;
	SUBC R3, 4;
	SUBC R0, 1;
	SUBC R1, 2;
	SUBC R2, 3;
	SUBC R3, 4;
	SUBC R0, 1;
	SUBC R1, 2;
	SUBC R2, 3;
	SUBC R3, 4;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	SUBC R0, 1;
	MULC R0, 2;
	MULC R2, 2;
	MULC R2, 3;
	MULC R3, 4;
	MULC R0, 2;
	MULC R2, 2;
	MULC R2, 3;
	MULC R3, 4;
	MULC R0, 2;
	MULC R2, 2;
	MULC R2, 3;
	MULC R3, 4;
	MULC R0, 0;
	ADDC R0, 1;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	MULC R0, 2;
	ADD R0, R1;
	ADD R1, R2;
	ADD R2, R3;
	ADD R3, R4;
	ADD R0, R1;
	ADD R1, R2;
	ADD R2, R3;
	ADD R3, R4;
	ADD R0, R1;
	ADD R1, R2;
	ADD R2, R3;
	ADD R3, R4;
	ADD R0, R1;
	ADD R1, R2;
	ADD R2, R3;
	ADD R3, R4;
	ADD R0, R1;
	ADD R1, R2;
	ADD R2, R3;
	ADD R3, R4;
	ADD R0, R1;
	ADD R0, R1;
	ADD R0, R1;
	ADD R0, R1;
	ADD R0, R1;
	ADD R0, R1;
	ADD R0, R1;
	SUB R0, R1;
	SUB R1, R2;
	SUB R2, R3;
	SUB R3, R4;
	SUB R0, R1;
	SUB R1, R2;
	SUB R2, R3;
	SUB R3, R4;
	SUB R0, R1;
	SUB R1, R2;
	SUB R2, R3;
	SUB R3, R4;
	SUB R0, R1;
	SUB R1, R2;
	SUB R2, R3;
	SUB R3, R4;
	SUB R0, R1;
	SUB R1, R2;
	SUB R2, R3;
	SUB R3, R4;
	SUB R0, R1;
	SUB R1, R2;
	SUB R2, R3;
	SUB R3, R4;
	SUB R0, R1;
	SUB R1, R2;
	SUB R2, R3;
	SUB R3, R4;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	SUB R0, R1;
	MUL R0, R2;
	MUL R2, R2;
	MUL R2, R3;
	MUL R3, R4;
	MUL R0, R2;
	MUL R2, R2;
	MUL R2, R3;
	MUL R3, R4;
	MUL R0, R2;
	MUL R2, R2;
	MUL R2, R3;
	MUL R3, R4;
	MUL R0, R0;
	ADD R0, R1;
	MULC R0, 0;
	MULC R2, 0;
	ADDC R0, 2;
	ADDC R2, 3;	
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	MUL R0, R2;
	NOT R0;
	SWAP RF, R0;
	CPY R4, RF;
	SHLA RF, 4;
	SHRA RF, 3;
	SHRA RF, 1;
	SHLL RF, 4;
	SHRL RF, 3;
	SHRL RF, 1;
	ROTL RF, 4;
	ROTR RF, 3;
	ROTR RF, 1;
	RTLC RF, 4;
	RTRC RF, 3;
	RTRC RF, 1;
.endcode;
