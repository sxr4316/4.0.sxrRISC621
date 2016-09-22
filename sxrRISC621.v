module sxrRISC621 (Resetn_pin, Clock_pin, SW_pin, Display_pin);

input		Resetn_pin, Clock_pin;

input		[4:0] SW_pin;			// Four switches and one push-button

output	[7:0] Display_pin;	// 8 LEDs

//----------------------------------------------------------------------------
//-- Declare machine cycle and instruction cycle parameters
//----------------------------------------------------------------------------

parameter [1:0] 		MC0 = 2'b00, MC1=2'b01, MC2=2'b10, MC3=2'b11;
	
parameter [5:0]		NOP_IC	=	6'b000000,			// 0x00
							
							LD_IC		=	6'b000001, 			//	0x01
							ST_IC		=	6'b000010,			// 0x02
							CPY_IC	=	6'b000011,			//	0x03
							SWAP_IC	=	6'b000100,			// 0x14
							
							JMP_IC	=	6'b010000,			//	0x10
							CALL_IC	=	6'b010001,			//	0x11
							RET_IC	=	6'b010010,			//	0x12
							
							ADD_IC	=	6'b100000,			//	0x20
							SUB_IC	=	6'b100001,			//	0x21
							ADDC_IC	=	6'b100010,			//	0x22
							SUBC_IC	=	6'b100011,			//	0x23
							MUL_IC	=	6'b100100,			//	0x24
							DIV_IC	=	6'b100101,			//	0x25
							MULC_IC	=	6'b100110,			//	0x26
							DIVC_IC	=	6'b100111,			//	0x27
							NOT_IC	=	6'b101000,			//	0x28
							AND_IC	=	6'b101001,			//	0x29
							OR_IC		=	6'b101010,			//	0x2A
							XOR_IC	=	6'b101011,			//	0x2B
							SHLL_IC	=	6'b101100,			//	0x2C
							SHRL_IC	=	6'b101101,			//	0x2D
							SHLA_IC	=	6'b101110,			//	0x2E
							SHRA_IC	=	6'b101111,			//	0x2F
							ROTL_IC	=	6'b110000,			//	0x30
							ROTR_IC	=	6'b110001,			//	0x31
							RTLC_IC	=	6'b110010,			//	0x32
							RTRC_IC	=	6'b110011;			//	0x33
							
	parameter [3:0]	JU		=	4'h0000,
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
	reg	[13:0]		R [15:0];
	reg					AddSubDir, WR_DM;
	reg	[1:0]			MC;
	reg	[13:0]		PC, IR, MAB, MAX, MAeff, SP, DM_in, IPDR;
	reg	[13:0]		TA, TB, TALUH, TALUL;
	reg	[11:0]		TSR, SR;
	reg	[7:0]			Display_pin;
	reg	[14:0]		TALUout;
	wire					Cflg, Vflg ;
	wire	[13:0]		PM_out, DM_out;
	wire	[27:0]		Mul_out;
	wire	[13:0]		AddSub_out, DivQuot_out, DivRem_out;
	wire					C, Clock_not;
	integer				Ri, Rj;

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

		sxrRISC621_rom		my_rom 	(PC[13:0], Clock_not, PM_out);
		
		sxrRISC621_ram		my_ram 	(MAeff[13:0], Clock_not, DM_in, WR_DM, DM_out);
		
		sxrRISC621_mult	my_mult 	(TA, TB, Mul_out);
		
		sxrRISC621_div		my_div	(TB, TA, DivQuot_out, DivRem_out);
		
		sxrRISC621_addsub	my_addsub(AddSubDir, TA, TB, Cflg, Vflg, AddSub_out);

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
						PC = 0;
						
						R[0] = 0; R[1] = 0; R[2] = 0; R[3] = 0; R[4] = 0; R[5] = 0; R[6] = 0; R[7] = 0;
						
						R[8] = 0; R[9] = 0; R[10] = 0; R[11] = 0; R[12] = 0; R[13] = 0; R[14] = 0; R[15] = 0;

						MAB = 0 ; MAX = 0 ; MAeff = 0 ;						

						SR = 0; TSR = 0;
						
						SP = 14'h3F00;
						
						MC = MC0;
						
						Display_pin = 8'h00;
					end
				else	begin
				
//----------------------------------------------------------------------------
// The first level CASE statement selects execution based on the current
// 	machine cycle.
//----------------------------------------------------------------------------
					case (MC)
					
						MC0: begin
								IR 	=	PM_out;
								
								Ri 	=	PM_out[7:4];								

								Rj 	=	PM_out[3:0];
									
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
						
							case (IR[13:8])
		
							LD_IC, ST_IC, JMP_IC:
									begin
										
										MAB = PM_out;
										
										PC 	=	PC + 1'b1;
										
										if ((Ri&15) == 0)
																		MAX = 0 ;
										else if ((Ri&15) == 1)
																		MAX = PC ;
										else if ((Ri&15) == 2)
																		MAX = SP ;
										else
																		MAX = R[(Ri&15)] ;
									end

							CALL_IC:
									begin
										
										MAB 	= PM_out;
										
										PC 	=	PC + 1'b1;
										
										if ((Ri&15) == 0)
																		MAX = 0 ;
										else if ((Ri&15) == 1)
																		MAX = PC ;
										else if ((Ri&15) == 2)
																		MAX = SP ;
										else
																		MAX = R[(Ri&15)] ;
										
										SP		=	SP - 1'b1 ;
										
									end
							
							RET_IC:
									begin
										MAeff	=	SP	;
										
										SP		=	SP	+	1'b1;
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
							
							MULC_IC, DIVC_IC:
									begin
										TA = R[Ri];
										TB = {10'b0000000000, IR[3:0]};
									end
									
							ADDC_IC:
									begin
										AddSubDir = 1'b1;
										TA = R[Ri];
										TB = {10'b0000000000, IR[3:0]};
									end
									
							SUBC_IC:
									begin
										AddSubDir = 1'b0;
										TA = R[Ri];
										TB = {10'b0000000000, IR[3:0]};
									end
									
							ADD_IC: 
									begin
										AddSubDir = 1'b1;
										TA = R[Ri];
										TB = R[Rj] ;
									end
							
							SUB_IC:
									begin
										AddSubDir = 1'b0;
										TA = R[Ri];
										TB = R[Rj] ;
									end
										
							NOT_IC, SHLL_IC, SHRL_IC, SHLA_IC, SHRA_IC, ROTL_IC, ROTR_IC, RTLC_IC, RTRC_IC:
									begin
										TA = R[Ri];
									end
							
							
							default: // SWAP_IC, ADD_IC, MUL_IC, DIV_IC, AND_IC, OR_IC, XOR_IC:
									begin
										TA = R[Ri];
										TB = R[Rj];
									end
							
							endcase
						
						MC = MC2;
						
						end

//----------------------------------------------------------------------------

						MC2:	begin

						case (IR[13:8])

						LD_IC, ST_IC, JMP_IC:
									begin
										MAeff = MAB + MAX;
										
										//----------------------------------------------
										// For LD_IC we ensure here that WR_DM=0.
										//----------------------------------------------
										WR_DM = 1'b0;
									end
			
						CALL_IC: 
									begin
										MAeff = SP ;
										
										DM_in = PC ;
										
										WR_DM = 1'b1;
										
										SP 	=	SP	-	1'b1	;
										
									end

						RET_IC  :
									begin
										
										SR		=	DM_out[11:0]	;
	
										TSR	=	DM_out[11:0]	;
										
										MAeff	=	SP ;
										
										SP		=	SP	+	1'b1;
										
										WR_DM	=	1'b0;
										
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
						
						ADD_IC, ADDC_IC, SUB_IC, SUBC_IC:
									begin
										TALUout = AddSub_out;
										TSR[11] = Cflg; 		  // Carry
										TSR[10] = TALUout[13]; // Negative
										TSR[9]  = Vflg; 		  // Overflow
										
										if (TALUout[13:0] == 0)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
											
										TALUH = TALUout[13:0];
									end
									
						MUL_IC:
									begin
										{TALUH, TALUL} = Mul_out;
										TSR[11] = 0; 												// Carry
										TSR[10] = TA[13]^TB[13]; 								// Negative
										TSR[9]  = 0; 												// Overflow
										
										if ((TALUH[13:0] == 0) && (TALUL[13:0] == 0))
											TSR[8] = 1;												// Zero
										else
											TSR[8] = 0;
									end

						MULC_IC:
									begin
										{TALUH, TALUL} = Mul_out;
										TSR[11] = TALUH[0]; 																			// Carry
										TSR[10] = TA[13]; 																			// Negative
										TSR[9]  = 0; 																					// Overflow
										
										if ((TALUH[13:0] == 0) && (TALUL[13:0] == 0))
											TSR[8] = 1;											// Zero
										else
											TSR[8] = 0;
									end
									
						DIV_IC, DIVC_IC:
									begin
										TALUH =	DivQuot_out ;
										
										TALUL	=	DivRem_out  ;

										TSR[11] = 0 ; 			  				 // Carry

										TSR[10] = TA[13]^TB[13]; 			 // Negative

										TSR[9] = 0; 							 // V Overflow
										
										if (TALUH[13:0] == 0)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
											
									end
									
						NOT_IC:
									begin
										TALUH = ~TA;
										TSR[10] = TALUH[13];   // Negative
										
										if (TALUH[13:0] == 0)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;

									end
						
						AND_IC:
									begin
										TALUH = TA & TB;
										
										TSR[10] = TALUH[13];   // Negative
										
										if (TALUH[13:0] == 0)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
									end

						OR_IC:
									begin
										TALUH = TA | TB;

										TSR[10] = TALUH[13]; // Negative
										
										if (TALUH[13:0] == 0)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
									end

									

						XOR_IC:
									begin
										TALUH = TA ^ TB;

										TSR[10] = TALUH[13]; // Negative
										
										if (TALUH[13:0] == 0)
											TSR[8] = 1;	// Zero
										else
											TSR[8] = 0;
									end

						
						SHLL_IC, SHLA_IC:
									begin
										case (Rj & 15)
										
											0: TALUH = TA;
												
											1: TALUH[13:0]={TA[12:0], 1'b0};
												
											2: TALUH[13:0]={TA[11:0], 2'b00};
												
											3: TALUH[13:0]={TA[10:0], 3'b000};
											
											4: TALUH[13:0]={TA[9:0], 4'b0000};
												
											5: TALUH[13:0]={TA[8:0], 5'b00000};
												
											6: TALUH[13:0]={TA[7:0], 6'b000000};
												
											7: TALUH[13:0]={TA[6:0], 7'b0000000};
											
											8: TALUH[13:0]={TA[5:0], 8'b00000000};
												
											9: TALUH[13:0]={TA[4:0], 9'b000000000};
												
											10: TALUH[13:0]={TA[3:0],10'b0000000000};
												
											11: TALUH[13:0]={TA[2:0],11'b00000000000};
											
											12: TALUH[13:0]={TA[1:0],12'b000000000000};
											
											13: TALUH[13:0]={TA[0], 13'b0000000000000};
											
											default : TALUH = 14'b00000000000000;
											
										endcase
									end
									
						SHRL_IC:
									begin
										
										case (Rj & 15)
										
											0:	TALUH = TA;
												
											1: TALUH[13:0]={1'b0, TA[13:1]};
												
											2:	TALUH[13:0]={2'b00, TA[13:2]};
											
											3: TALUH[13:0]={3'b000, TA[13:3]};

											4: TALUH[13:0]={4'b0000, TA[13:4]};											

											5: TALUH[13:0]={5'b00000, TA[13:5]};											

											6: TALUH[13:0]={6'b000000, TA[13:6]};											

											7: TALUH[13:0]={7'b0000000, TA[13:7]};											

											8: TALUH[13:0]={8'b00000000, TA[13:8]};											

											9: TALUH[13:0]={9'b000000000, TA[13:9]};											

											10: TALUH[13:0]={10'b0000000000, TA[13:10]};											

											11: TALUH[13:0]={11'b00000000000, TA[13:11]};											

											12: TALUH[13:0]={12'b000000000000, TA[13:12]};											

											13: TALUH[13:0]={13'b0000000000000, TA[13]};											

											default : TALUH = 14'b00000000000000;
											
										endcase
										
									end
						
						SHRA_IC:
									begin
										case (Rj & 15)
										
											0 : TALUH = {{{(1){TA[13]}}}, TA[12:0]};
											
											1 : TALUH = {{{(2){TA[13]}}}, TA[12:1]};
											
											2 : TALUH = {{{(3){TA[13]}}}, TA[12:2]};
											
											3 : TALUH = {{{(4){TA[13]}}}, TA[12:3]};
											
											4 : TALUH = {{{(5){TA[13]}}}, TA[12:4]};
											
											5 : TALUH = {{{(6){TA[13]}}}, TA[12:5]};
											
											6 : TALUH = {{{(7){TA[13]}}}, TA[12:6]};
											
											7 : TALUH = {{{(8){TA[13]}}}, TA[12:7]};
											
											8 : TALUH = {{{(9){TA[13]}}}, TA[12:8]};
											
											9 : TALUH = {{{(10){TA[13]}}}, TA[12:9]};
											
											10: TALUH = {{{(11){TA[13]}}}, TA[12:10]};
											
											11: TALUH = {{{(12){TA[13]}}}, TA[12:11]};
											
											12: TALUH = {{{(13){TA[13]}}}, TA[12]};
										
											default : TALUH = {14{TA[13]}};
											
										endcase
									end
									
						ROTL_IC:
									begin
										case (Rj & 15)
										
											0,14: TALUH = TA;
												
											1,15: TALUH = {TA[12:0], TA[13]};
												
											2: TALUH = {TA[11:0], TA[13:12]};
												
											3: TALUH = {TA[10:0], TA[13:11]};
											
											4: TALUH = {TA[9:0], TA[13:10]};
											
											5: TALUH = {TA[8:0], TA[13:9]};

											6: TALUH = {TA[7:0], TA[13:8]};
											
											7: TALUH = {TA[6:0], TA[13:7]};

   										8: TALUH = {TA[5:0], TA[13:6]};

											9: TALUH = {TA[4:0], TA[13:5]};

											10: TALUH = {TA[3:0], TA[13:4]};

											11: TALUH = {TA[2:0], TA[13:3]};

											12: TALUH = {TA[1:0], TA[13:2]};

											13: TALUH = {TA[0], TA[13:1]};

										default : TALUH = TA;
											
										endcase
									end

						ROTR_IC:
									begin
										case (Rj & 15)
										
											0,14: TALUH = TA;
												
											1,15: TALUH = {TA[0], TA[13:1]};
												
											2: TALUH = {TA[1:0], TA[13:2]};
												
											3: TALUH = {TA[2:0], TA[13:3]};
												
											4: TALUH = {TA[3:0], TA[13:4]};
												
											5: TALUH = {TA[4:0], TA[13:5]};
											
											6: TALUH = {TA[5:0], TA[13:6]};
												
											7: TALUH = {TA[6:0], TA[13:7]};												
											
											8: TALUH = {TA[7:0], TA[13:8]};
												
											9: TALUH = {TA[8:0], TA[13:9]};												
											
											10: TALUH = {TA[9:0], TA[13:10]};
												
											11: TALUH = {TA[10:0], TA[13:11]};												
											
											12: TALUH = {TA[11:0], TA[13:12]};
												
											13: TALUH = {TA[12:0], TA[13]};												
											
											default : TALUH = TA;
											
										endcase
									end									

						RTLC_IC:
									begin
										case (Rj & 15)
												
											1: begin TALUH = {TA[12:0], TSR[11]}; 					TSR[11] = TA[13]; end
												
											2: begin TALUH = {TA[11:0], TSR[11], TA[13]}; 		TSR[11] = TA[12]; end 
												
											3: begin TALUH = {TA[10:0], TSR[11], TA[13:12]}; 	TSR[11] = TA[11]; end
											
											4: begin TALUH = {TA[9:0], TSR[11], TA[13:11]}; 	TSR[11] = TA[10]; end
												
											5: begin TALUH = {TA[8:0], TSR[11], TA[13:10]}; 	TSR[11] = TA[9]; end
												
											6: begin TALUH = {TA[7:0], TSR[11], TA[13:9]}; 		TSR[11] = TA[8]; end
											
											7: begin TALUH = {TA[6:0], TSR[11], TA[13:8]}; 		TSR[11] = TA[7]; end
												
											8: begin TALUH = {TA[5:0], TSR[11], TA[13:7]}; 		TSR[11] = TA[6]; end
												
											9: begin TALUH = {TA[4:0], TSR[11], TA[13:6]}; 		TSR[11] = TA[5]; end
											
											10: begin TALUH = {TA[3:0], TSR[11], TA[13:5]}; 	TSR[11] = TA[4]; end
												
											11: begin TALUH = {TA[2:0], TSR[11], TA[13:4]}; 	TSR[11] = TA[3]; end
												
											12: begin TALUH = {TA[1:0], TSR[11], TA[13:3]}; 	TSR[11] = TA[2]; end
											
											13: begin TALUH = {TA[0], TSR[11], TA[13:2]}; 		TSR[11] = TA[1]; end
												
											14: begin TALUH = {TSR[11], TA[13:1] }; 				TSR[11] = TA[0]; end
												
											default : TALUH = TA;
											
										endcase
									end

						RTRC_IC:
									begin
										case (Rj & 15)
																							
											1: begin TALUH = {TSR[11], TA[13:1]}; 					TSR[11] = TA[0]; end
												
											2: begin TALUH = {TA[0], TSR[11], TA[13:2]}; 		TSR[11] = TA[1]; end
												
											3: begin TALUH = {TA[1:0], TSR[11], TA[13:3]}; 		TSR[11] = TA[2]; end
												
											4: begin TALUH = {TA[2:0], TSR[11], TA[13:4]}; 		TSR[11] = TA[3]; end
												
											5: begin TALUH = {TA[3:0], TSR[11], TA[13:5]}; 		TSR[11] = TA[4]; end
												
											6: begin TALUH = {TA[4:0], TSR[11], TA[13:6]}; 		TSR[11] = TA[5]; end												
											
											7: begin TALUH = {TA[5:0], TSR[11], TA[13:7]}; 		TSR[11] = TA[6]; end
												
											8: begin TALUH = {TA[6:0], TSR[11], TA[13:8]}; 		TSR[11] = TA[7]; end
												
											9: begin TALUH = {TA[7:0], TSR[11], TA[13:9]}; 		TSR[11] = TA[8]; end												
											
											10: begin TALUH = {TA[8:0], TSR[11], TA[13:10]}; 	TSR[11] = TA[9]; end
												
											11: begin TALUH = {TA[9:0], TSR[11], TA[13:11]}; 	TSR[11] = TA[10]; end
												
											12: begin TALUH = {TA[10:0], TSR[11], TA[13:12]}; 	TSR[11] = TA[11]; end												
											
											13: begin TALUH = {TA[11:0], TSR[11], TA[13]}; 		TSR[11] = TA[12]; end
												
											14: begin TALUH = {TA[12:0], TSR[11]}; 				TSR[11] = TA[13]; end
												
											default : TALUH = TA;
											
										endcase
									end			

						default:
									MC = MC0;
					endcase
						
						MC = MC3;
					
					end

//----------------------------------------------------------------------------

						 MC3:	begin
							case (IR[13:8])
								 
								 LD_IC:
									begin
										if (MAeff[13:6] != 8'hFF)
											R[Rj&15] = DM_out;
										else
											R[Rj&15] = 14'h000;					// IO Peripherals to be checked
									end
		
								 ST_IC:
									begin
										if (MAeff[13:6] != 8'hFF) begin
											DM_in	=	R[Rj&15];
											
											WR_DM =	1'b1;
										end
									end

								 CPY_IC:
									begin
										R[Rj&15] = TALUL;
									end
								 
								 SWAP_IC:
									begin
										R[Rj&15] = TALUL;
										R[Ri&15] = TALUH;
									end
								 
								 JMP_IC:
									begin
										case (Rj&15)
										
											JU:
														PC = MAeff;
															
											JC1, JN1, JV1, JZ1:
												begin
													if ((SR[11:8])&(Rj&15) == (Rj&15))
														PC = MAeff;
													else
														PC = PC;
												end
											
											
											JC0, JN0, JV0, JZ0:
												begin
													if ((SR[11:8])|(Rj&15) == (Rj&15))
														PC = MAeff;
													else
														PC = PC;
												end											
										endcase
									end
																	 									
								 CALL_IC:
									begin
										MAeff = SP ;
										
										DM_in = SR ;
										
										WR_DM = 1'b1;
										
										PC		=	MAB + MAX	;
									end
								 
								 RET_IC:
									begin
										
										PC		=	DM_out	;
	
										WR_DM	=	1'b0;
										
									end


									
									ADD_IC, SUB_IC, ADDC_IC, SUBC_IC,
									NOT_IC, AND_IC, OR_IC, XOR_IC, 
									SHLL_IC, SHRL_IC, SHLA_IC, SHRA_IC, ROTL_IC, ROTR_IC, RTLC_IC, RTRC_IC:
										begin
											R[Ri] = TALUH;
											SR = TSR;
										end
									 
									MUL_IC, DIV_IC:
										begin
											R[Ri] = TALUH;
											R[Rj] = TALUL;
											SR = TSR;
										end
									
									MULC_IC:
										begin
											R[Ri] = TALUL;
											
											SR = TSR;
										end
										
									DIVC_IC:
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