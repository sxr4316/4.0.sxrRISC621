module sxrRISC621 (Resetn_pin, Clock_pin, SW_pin, Display_pin);

input	Resetn_pin, Clock_pin;

input	[4:0] SW_pin;			// Four switches and one push-button

output [7:0] Display_pin;	// 8 LEDs

//----------------------------------------------------------------------------
//-- Declare machine cycle and instruction cycle parameters
//----------------------------------------------------------------------------

	parameter [1:0] MC0 = 2'b00, MC1=2'b01, MC2=2'b10, MC3=2'b11;
	
	parameter [5:0]	LD_IC		=	6'b000000, 
							ST_IC		=	6'b000001,
							CPY_IC	=	6'b000010,
							SWAP_IC	=	6'b000011,
							
							JMP_IC	=	6'b000100,
							CALL_IC	=	6'b000101,
							RET_IC	=	6'b000110,
							
							ADD_IC	=	6'b100000,
							SUB_IC	=	6'b100001,
							ADDC_IC	=	6'b100010,
							SUBC_IC	=	6'b100011,
							MUL_IC	=	6'b100100,
							DIV_IC	=	6'b100101,
							MULC_IC	=	6'b100110,
							DIVC_IC	=	6'b100111,
							NOT_IC	=	6'b101000,
							AND_IC	=	6'b101001,
							OR_IC		=	6'b101010,
							XOR_IC	=	6'b101011,
							SHLL_IC	=	6'b101100,
							SHRL_IC	=	6'b101101,
							SHLA_IC	=	6'b101110,
							SHRA_IC	=	6'b101111,
							ROTL_IC	=	6'b110000,
							ROTR_IC	=	6'b110001,
							RTLC_IC	=	6'b110010;
							
	parameter [3:0]	JU		=	4'b0000,
							JC1	=	4'b1000,
							JN1	=	4'b0100,
							JV1	=	4'b0010,
							JZ1	=	4'b0001,
							JC0	=	4'b0111,
							JN0	=	4'b1011,
							JV0	=	4'b1101,
							JZ0	=	4'b1110;

//----------------------------------------------------------------------------
//-- Declare internal signals
//----------------------------------------------------------------------------
	reg	[11:0]	R [7:0];
	reg				WR_DM;
	reg	[1:0]		MC;
	reg	[11:0]	PC, IR, MAB, MAX, MAeff, SP, DM_in, IPDR;
	reg	[11:0]	TA, TB, TALUH, TALUL;
	reg	[11:0]	TSR, SR;
	reg	[7:0]		Display_pin;
	reg	[12:0]	TALUout;
	wire	[11:0]	PM_out, DM_out;
	wire	[12:0]	Mul_out, Div_out;
	wire				C, Clock_not;
	integer			Ri, Rj;

//----------------------------------------------------------------------------
// In this architecture we are using a combination of structural and 
// 	behavioral code.  Care has to be excercised because the values assigned
//		in the process are visible outside of it only during the next clock 
//		cycle.  The CPU comprised of the DP and CU is modeled as a combination
// 	of CASE and IF statements (behavioral).  The memories are called within
// 	the structural part of the code.  We could model the memories as
//		arrays, but that would result in less than optimal memory 
//		implementations.  Also, later on we will want to add an hierarchcial 
//		memory subsystem.
//----------------------------------------------------------------------------
// Structural section of the code.  The order of the assignments doesn't 
// 	matter.  Concurrency!
//----------------------------------------------------------------------------

		assign	Clock_not = ~Clock_pin;

//----------------------------------------------------------------------------
// Instantiating only 1KWord memories to save resources
//----------------------------------------------------------------------------

		my_rom	sxrRISC621_rom		(PC[11:0], Clock_not, PM_out);
		
		my_ram	sxrRISC621_ram		(MAeff[11:0], Clock_not, DM_in, WR_DM, DM_out);
		
		my_mult	sxrRISC621_mult	(TA, TB, Mul_out);
		
		my_div	sxrRISC621_div		(TA, TB, Div_out);

//----------------------------------------------------------------------------
//	Behavioral section of the code.  Assignments are evaluated in order, i.e.
// 	sequentially. New assigned values are visible outside the always block 
// 	only after it is exit.  Last assigned value will be the exit value.
//----------------------------------------------------------------------------

always@(posedge Clock_pin)
//----------------------------------------------------------------------------
// The reset is active low and clock synchronous.  For verification/simulation
// 	purposes it is necessary in this case to initialize the value of regA.
//----------------------------------------------------------------------------
				if (Resetn_pin == 0)
					begin	
						PC = 12'h000;
						R[0] = 0; R[1] = 0; R[2] = 0; R[3] = 0; R[4] = 0; R[5] = 0; R[6] = 0; R[7] = 0;// Necessary for sim
						MC = MC0;
					end
				else	begin
				
//----------------------------------------------------------------------------
// The first level CASE statement selects execution based on the current
// 	machine cycle.
//----------------------------------------------------------------------------
					case (MC)
						MC0:
							begin
								IR 	=	PM_out;
								
								Rj 	=	PM_out[2:0];
								
								Ri 	=	PM_out[5:3];
									
								PC 	=	PC + 1'b1;
								
								WR_DM =	1'b0;
								
								MC 	=	MC1;
							end
							
//----------------------------------------------------------------------------
// The second level CASE statements select assignments based on the OpCodes.
// You could switch the case statements, i.e. have the OpCodes at the first
// 	level and the MCs at the second level.
//----------------------------------------------------------------------------
						MC1: begin
						
							case (IR[11:6])
		
							LD_IC, ST_IC:
									begin
											// IR[7] is replicated to maintain the sign in 2's - Complement
										MAB = {{8{IR[7]}}, IR[7:0]};
										if (Ri == 0)
											MAX = 0;
										else
											MAX = R[Ri];
									end
							
							CPY_IC:
									begin
										TB = R[Rj];
									end
									
							SWAP_IC:
									begin
										TA = R[Ri];
										TB = R[Rj];
									end
							
							JMP_IC:
									begin
											// IR[7] is replicated to maintain the sign in 2's - Complement
										MAB = {{10{IR[5]}}, IR[5:0]};
										if (Ri == 0)
											MAX = 0;
										else
											MAX = R[Ri];
									end
									
							CALL_IC, RET_IC:
							
									begin
											// IR[7] is replicated to maintain the sign in 2's - Complement
										MAB = {{10{IR[5]}}, IR[5:0]};
										if (Ri == 0)
											MAX = 0;
										else
											MAX = R[Ri];
									end
							
							
							ADDC_IC, SUBC_IC:
									begin
										TA = R[Ri];
										TB = {9'b000000000, IR[2:0]};
									end
									
							MULC_IC, DIVC_IC:
									begin
										TA = R[Ri];
										TB = {9'b000000000, IR[2:0]};
									end
							
							NOT_IC, SHLL_IC, SHRL_IC, SHLA_IC, SHRA_IC, ROTL_IC, ROTR_IC, RTLC_IC:
									begin
										TA = R[Ri];
									end
									
							
							default: 
											// SWAP_IC, ADD_IC, MUL_IC, DIV_IC, SUB_IC, AND_IC, OR_IC, XOR_IC:
									begin
										TA = R[Ri];
										TB = R[Rj];
									end
							
							endcase
						
						MC = MC2;
						
						end

//----------------------------------------------------------------------------

						MC2:	begin

						case (IR[11:6])

						LD_IC, JMP_IC:
									begin
										MAeff = MAB + MAX;
										//----------------------------------------------
										// For LD_IC we ensure here that WR_DM=0.
										//----------------------------------------------
										WR_DM = 1'b0;
									end

						ST_IC:
									begin
										if (MAeff[11:4] != 12'hFFF)
											begin
												MAeff = MAB + MAX;
												WR_DM = 1'b1;
												DM_in = R[Rj];
											end
										else
											WR_DM = 1'b0;
									end
						
						CPY_IC:
									begin
										TALUL = TB;
									end
								SWAP_IC:
									begin
										TALUH = TA;
										TALUL = TB;
									end
//----------------------------------------------------------------------------
// For all assignments that target TALUH we use TALUout.  This is 17-bits wide
// 	to account for the value of the carry when necessary.
//----------------------------------------------------------------------------
						
						ADD_IC, ADDC_IC:
									begin
										TALUout = TA + TB;
										TSR[11] = TALUout[12]; // Carry
										TSR[10] = TALUout[11]; // Negative
										TSR[9] = ((TA[11] ~^ TB[11]) & TA[11]) ^ (TALUout[11] & (TA[11] ~^ TB[11])); // Overflow
										
										if (TALUout[11:0] == 12'h000)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
											
										TALUH = TALUout[11:0];
									end
									
						SUB_IC, SUBC_IC:
									begin
										TALUout = TA - TB;
										TSR[11] = TALUout[12]; // Carry
										TSR[10] = TALUout[11]; // Negative
										TSR[9] = ((TA[11] ~^ TB[11]) & TA[11]) ^ (TALUout[11] & (TA[11] ~^ TB[11])); // V Overflow
										
										if (TALUout[11:0] == 12'h000)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
											
										TALUH = TALUout[11:0];
									end
									
						MUL_IC, MULC_IC:
									begin
										TALUout = Mul_out;
										TSR[11] = TALUout[12]; // Carry
										TSR[10] = TALUout[11]; // Negative
										TSR[9] = ((TA[11] ~^ TB[11]) & TA[11]) ^ (TALUout[11] & (TA[11] ~^ TB[11])); // Overflow
										
										if (TALUout[11:0] == 12'h000)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
											
										TALUH = TALUout[11:0];
									end
									
						DIV_IC, DIVC_IC:
									begin
										TALUout = Div_out;

										TSR[11] = 0 ; 			  // Carry

										TSR[10] = TALUout[11]; // Negative

										TSR[9] = ((TA[11] ~^ TB[11]) & TA[11]) ^ (TALUout[11] & (TA[11] ~^ TB[11])); // V Overflow
										
										if (TALUout[11:0] == 12'h000)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
											
										TALUH = TALUout[11:0];
									end
									
						NOT_IC:
									begin
										TALUH = ~TA;
									end
						
						AND_IC:
									begin
										TALUH = TA & TB;
										
										TSR[10] = TALUH[11];   // Negative
										
										if (TALUH[11:0] == 12'h000)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
									end
									
						XOR_IC:
									begin
										TALUH = TA ^ TB;

										TSR[10] = TALUH[11]; // Negative
										
										if (TALUH[11:0] == 12'h000)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
									end

						OR_IC:
									begin
										TALUH = TA | TB;

										TSR[10] = TALUH[11]; // Negative
										
										if (TALUH[11:0] == 12'h000)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
									end
						
						SHLL_IC:
									begin
										case (Rj)
											0:
												begin
													TALUH = TA;
												end
											1:
												begin
													TALUH[11:0]={TA[10:0], 1'b0};
												end
											2:
												begin
													TALUH[11:0]={TA[9:0], 2'b00};
												end
											3:
												begin
													TALUH[11:0]={TA[8:0], 3'b000};
												end
											4:
												begin
													TALUH[11:0]={TA[7:0], 4'b0000};
												end
											5:
												begin
													TALUH[11:0]={TA[6:0], 5'b00000};
												end
											6:
												begin
													TALUH[11:0]={TA[5:0], 6'b000000};
												end
											7:
												begin
													TALUH[11:0]={TA[4:2], 7'b0000000};
												end
										endcase
									end
									
						SHRL_IC:
									begin
										
										case (Rj)
											0:	TALUH = TA;
												
											1: TALUH[11:0]={1'b0, TA[11:1]};
												
											2:	TALUH[11:0]={2'b00, TA[11:2]};
											
											3: TALUH[11:0]={3'b000, TA[11:3]};

											4: TALUH[11:0]={4'b0000, TA[11:4]};

											5: TALUH[11:0]={5'b00000, TA[11:5]};

											6: TALUH[11:0]={6'b000000, TA[11:6]};

											7: TALUH[11:0]={7'b0000000, TA[11:7]};
										endcase
										
									end
						
						SHLA_IC:
									begin
										case (Rj)
											0:	TALUH = TA;
										
											1:	TALUH = {TA[11], TALUH[9:0], 1'b0};
											
											2: TALUH = {TA[11], TALUH[8:0], 2'b00};
													
											3:	TALUH = {TA[11], TALUH[7:0], 3'b000};
											
											4:	TALUH = {TA[11], TALUH[6:0], 4'b0000};
											
											5: TALUH = {TA[11], TALUH[5:0], 5'b00000};
													
											6:	TALUH = {TA[11], TALUH[4:0], 6'b000000};

											7:	TALUH = {TA[11], TALUH[3:0], 7'b0000000};
										endcase
									end
						
						
						
						SHRA_IC:
									begin
										case (Rj)
											1:	TALUH = {TA[11], TA[11], TALUH[9:0]};
											
											2: TALUH = {TA[11], TA[11], TA[11], TALUH[8:0]};
													
											3:	TALUH = {TA[11], TA[11], TA[11], TA[11], TALUH[7:0]};
											
											4:	TALUH = {TA[11], TA[11], TA[11], TA[11], TA[11], TALUH[6:0]};
											
											5: TALUH = {TA[11], TA[11], TA[11], TA[11], TA[11], TA[11], TALUH[5:0]};
													
											6:	TALUH = {TA[11], TA[11], TA[11], TA[11], TA[11], TA[11], TA[11], TALUH[4:0]};

											7:	TALUH = {TA[11], TA[11], TA[11], TA[11], TA[11], TA[11], TA[11], TA[11], TALUH[3:0]};
										endcase
									end
									
						ROTR_IC:
									begin
										case (Rj)
											0:
												begin
													TALUH = TA;
												end
											1:
												begin
													TALUH[11]=TSR[11]; TALUH[10:0]=TA[11:1]; TSR[11] = TA[0];
												end
											2:
												begin
													TALUH[11]=TA[0]; TALUH[10]=TSR[11]; TALUH[9:0]=TA[11:2]; TSR[11] = TA[1];
												end
											3:
												begin
													TALUH[11]=TA[1]; TALUH[10]=TA[0]; TALUH[9]=TSR[11]; 
													TALUH[8:0]=TA[11:3]; TSR[11] = TA[2];
												end
										endcase
									end
						
						default:
									MC = MC0;
						endcase
						
						MC = MC3;
					
					end
//----------------------------------------------------------------------------
						 MC3:	begin
							case (IR[11:6])
								 LD_IC:
									begin
										if (MAeff[11:4] == 12'hFFF)
											if (MAeff[3:0] == 4'hF)
												R[IR[9:8]] = SP;
											else
												R[IR[9:8]] = {11'b00000000000, SW_pin};												
										else
											R[IR[9:8]] = DM_out;
									end
								 ST_IC:
									begin
										if (MAeff[11:4] == 12'hFFF)
											if (MAeff[3:0] == 4'hF)
												SP = R[IR[9:8]];
											else
												Display_pin = R[IR[9:8]][7:0];												
										else
											MC = MC0;
									end
								 CPY_IC:
									begin
										R[IR[11:10]] = TALUL;
									end
								 SWAP_IC:
									begin
										R[IR[11:10]] = TALUL;
										R[IR[9:8]] = TALUH;
									end
								 JMP_IC:
									begin
										case (IR[9:6])
											JC1:
												begin
													if (SR[11] == 1)
													PC = MAeff;
													else
													PC = PC;
												end
											JN1:
												begin
													if (SR[10] == 1)
													PC = MAeff;
													else
													PC = PC;
												end
											JV1:
												begin
													if (SR[9] == 1)
													PC = MAeff;
													else
													PC = PC;
												end
											JZ1:
												begin
													if (SR[8] == 1)
													PC = MAeff;
													else
													PC = PC;
												end
											JC0:
												begin
													if (SR[11] == 0)
													PC = MAeff;
													else
													PC = PC;
												end
											JN0:
												begin
													if (SR[10] == 0)
													PC = MAeff;
													else
													PC = PC;
												end
											JV0:
												begin
													if (SR[9] == 0)
													PC = MAeff;
													else
													PC = PC;
												end
											JZ0:
												begin
													if (SR[8] == 0)
													PC = MAeff;
													else
													PC = PC;
												end
										endcase
									end
									ADD_IC, SUB_IC, ADDC_IC, SUBC_IC, NOT_IC, AND_IC, OR_IC, SHRA_IC, ROTR_IC:
										begin
											R[Ri] = TALUH;
											SR = TSR;
										end
								 default:
									MC = MC0;
							endcase
							MC = MC0;
						 end
						 default:
							MC = MC0;
					endcase
				end
endmodule