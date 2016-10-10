//lpm_divide CBX_SINGLE_OUTPUT_FILE="ON" LPM_DREPRESENTATION="SIGNED" LPM_HINT="LPM_REMAINDERPOSITIVE=FALSE" LPM_NREPRESENTATION="SIGNED" LPM_TYPE="LPM_DIVIDE" LPM_WIDTHD=14 LPM_WIDTHN=14 denom numer quotient remain
//VERSION_BEGIN 15.1 cbx_mgl 2015:10:21:19:02:34:SJ cbx_stratixii 2015:10:14:18:59:15:SJ cbx_util_mgl 2015:10:14:18:59:15:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, the Altera Quartus Prime License Agreement,
//  the Altera MegaCore Function License Agreement, or other 
//  applicable license agreement, including, without limitation, 
//  that your use is for the sole purpose of programming logic 
//  devices manufactured by Altera and sold by Altera or its 
//  authorized distributors.  Please refer to the applicable 
//  agreement for further details.



//synthesis_resources = lpm_divide 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mgp6k
	( 
	denom,
	numer,
	quotient,
	remain) /* synthesis synthesis_clearbox=1 */;
	input   [13:0]  denom;
	input   [13:0]  numer;
	output   [13:0]  quotient;
	output   [13:0]  remain;

	wire  [13:0]   wire_mgl_prim1_quotient;
	wire  [13:0]   wire_mgl_prim1_remain;

	lpm_divide   mgl_prim1
	( 
	.denom(denom),
	.numer(numer),
	.quotient(wire_mgl_prim1_quotient),
	.remain(wire_mgl_prim1_remain));
	defparam
		mgl_prim1.lpm_drepresentation = "SIGNED",
		mgl_prim1.lpm_nrepresentation = "SIGNED",
		mgl_prim1.lpm_type = "LPM_DIVIDE",
		mgl_prim1.lpm_widthd = 14,
		mgl_prim1.lpm_widthn = 14,
		mgl_prim1.lpm_hint = "LPM_REMAINDERPOSITIVE=FALSE";
	assign
		quotient = wire_mgl_prim1_quotient,
		remain = wire_mgl_prim1_remain;
endmodule //mgp6k
//VALID FILE
