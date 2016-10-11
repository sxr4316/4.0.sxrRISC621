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
                JMP     @forward;                  // Unconditional Forward JUMP
                ST      RA, M[R1+0x32A0];          // STORE Instruction
                JMPN    @forward;                  // Forward JUMP when bit is true
                JMPNV   @forward;                  // Forward JUMP when bit is false
                SUB     R0, R0;
@backward       SUB     R1, R1;
                ADDC    R0, 03;
                SHRL    R0, 01;
                CALL    @Routine;                   //  CALL Instruction Forward
                CALL    @backward;                  //  CALL Instruction backward
                SHRL    R0, 02;
                SHLL    R0, 00;
@forward        ADDC    R0, 03;
                SHLL    R0, 02;
                SHLL    R0, 01;
                LD      RA, M[SP+3200];            // LOAD to decimal offset
                LD      R5, M[R3+0x3FA0];          // LOAD to hexadecimal offset
                JMP     @backward;                 // Unconditional Backward JUMP
@Routine        JMPZ    @forward;                  // Backward JUMP when bit is true
                JMPNC   @backward;                 // Backward JUMP when bit is false
                RET;                               // RETURN Instruction
.endcode;
