// megafunction wizard: %LPM_DIVIDE%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: LPM_DIVIDE 

// ============================================================
// File Name: sxrRISC621_div.v
// Megafunction Name(s):
// 			LPM_DIVIDE
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 16.0.0 Build 211 04/27/2016 SJ Standard Edition
// ************************************************************

//Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, the Altera Quartus Prime License Agreement,
//the Altera MegaCore Function License Agreement, or other 
//applicable license agreement, including, without limitation, 
//that your use is for the sole purpose of programming logic 
//devices manufactured by Altera and sold by Altera or its 
//authorized distributors.  Please refer to the applicable 
//agreement for further details.

module sxrRISC621_div (
	denom,
	numer,
	quotient,
	remain);

	input	[11:0]  denom;
	input	[11:0]  numer;
	output	[11:0]  quotient;
	output	[11:0]  remain;

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone V"
// Retrieval info: PRIVATE: PRIVATE_LPM_REMAINDERPOSITIVE STRING "FALSE"
// Retrieval info: PRIVATE: PRIVATE_MAXIMIZE_SPEED NUMERIC "-1"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
// Retrieval info: PRIVATE: USING_PIPELINE NUMERIC "0"
// Retrieval info: PRIVATE: VERSION_NUMBER NUMERIC "2"
// Retrieval info: PRIVATE: new_diagram STRING "1"
// Retrieval info: LIBRARY: lpm lpm.lpm_components.all
// Retrieval info: CONSTANT: LPM_DREPRESENTATION STRING "SIGNED"
// Retrieval info: CONSTANT: LPM_HINT STRING "LPM_REMAINDERPOSITIVE=FALSE"
// Retrieval info: CONSTANT: LPM_NREPRESENTATION STRING "SIGNED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "LPM_DIVIDE"
// Retrieval info: CONSTANT: LPM_WIDTHD NUMERIC "12"
// Retrieval info: CONSTANT: LPM_WIDTHN NUMERIC "12"
// Retrieval info: USED_PORT: denom 0 0 12 0 INPUT NODEFVAL "denom[11..0]"
// Retrieval info: USED_PORT: numer 0 0 12 0 INPUT NODEFVAL "numer[11..0]"
// Retrieval info: USED_PORT: quotient 0 0 12 0 OUTPUT NODEFVAL "quotient[11..0]"
// Retrieval info: USED_PORT: remain 0 0 12 0 OUTPUT NODEFVAL "remain[11..0]"
// Retrieval info: CONNECT: @denom 0 0 12 0 denom 0 0 12 0
// Retrieval info: CONNECT: @numer 0 0 12 0 numer 0 0 12 0
// Retrieval info: CONNECT: quotient 0 0 12 0 @quotient 0 0 12 0
// Retrieval info: CONNECT: remain 0 0 12 0 @remain 0 0 12 0
// Retrieval info: GEN_FILE: TYPE_NORMAL sxrRISC621_div.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL sxrRISC621_div.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL sxrRISC621_div.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL sxrRISC621_div.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL sxrRISC621_div_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL sxrRISC621_div_bb.v TRUE
// Retrieval info: LIB_FILE: lpm
