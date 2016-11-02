module sxrRISC621_crom	(Resetn, StBusy, PM_address, Clock, PM_out);

//----------------------------------------------------------------------------
//module input and outputs
//----------------------------------------------------------------------------

input		[13:0]	PM_address;
input					Resetn, Clock;
output	[13:0]	PM_out;
output				StBusy;

//----------------------------------------------------------------------------
//structural nets
//----------------------------------------------------------------------------

wire	[1:0]	mbits0, mbits1, grp, PMM_out;
wire			c0, c1, c2;
wire	[7:0]	dout0, dout1;

//----------------------------------------------------------------------------
//registered nets
//----------------------------------------------------------------------------

reg				we_n0, we_n1 ,we_n2, we_n3 , rd_n0, rd_n1 , rd_n2, rd_n3;
reg				miss, wren;
reg	[1:0]		replace	[3:0];
reg				StBusy;

//----------------------------------------------------------------------------
// PMC_address is the cache memory address
//----------------------------------------------------------------------------

reg	[8:0]		PMC_address; 

//----------------------------------------------------------------------------
// PMM_address is the PM memory address;
//----------------------------------------------------------------------------

reg	[13:0] PMM_address; 
reg	[7:0] din0, din1, din2, din3;
reg	[3:0] cam_addrs0, cam_addrs1;
reg	[4:0] transfer_count;

//----------------------------------------------------------------------------
// i is used to capture the group address field
//----------------------------------------------------------------------------

reg	[1:0]	i;

//----------------------------------------------------------------------------
// 8-bit Block Address | 2-bit Group Address | 4-bit Word Address
//----------------------------------------------------------------------------
// Structural part of the code = memory subsystem "data path"
//----------------------------------------------------------------------------
// The PLL unit/block generates three clock phases to sequence all events
//----------------------------------------------------------------------------

	sxrRISC621_pll	rom_pll 	(Clock, c0, c1, c2);
	
//----------------------------------------------------------------------------
// I'm using two separate CAM memories for the two-way TAG identification
//----------------------------------------------------------------------------

	sxrRISC621_cam	RomBank0	(we_n0, rd_n0, din0, PM_address[13:6], cam_addrs0, dout0, mbits0);
	
	sxrRISC621_cam	RomBank1	(we_n1, rd_n1, din1, PM_address[13:6], cam_addrs1, dout1, mbits1);
	
	sxrRISC621_cam	RomBank2	(we_n2, rd_n2, din2, PM_address[13:6], cam_addrs2, dout2, mbits2);
	
	sxrRISC621_cam	RomBank3	(we_n3, rd_n3, din3, PM_address[13:6], cam_addrs3, dout3, mbits3);
	
//----------------------------------------------------------------------------
// This is the actual PM ROM, the same one that was used before as a 
//    monolithic PM memory; notice that this is driven by the c1 phase of the 
//    clock.
//----------------------------------------------------------------------------

	sxrRISC621_rom 	my_rom   (PMM_address[13:0], C1, PMM_out);
	
//----------------------------------------------------------------------------
// This is the actual cache memory, implemented as a RAM; notice that this
//    is using the c2 phase of the clock.
//----------------------------------------------------------------------------

	sxrRISC621_cache	my_rom_cache	(PMC_address, c2, PMM_out, wren, PM_out);
	
//----------------------------------------------------------------------------
// This 4to16 decoder identifies the group being accessed
//----------------------------------------------------------------------------

	sxrRISC621_grp		my_romgrpdec	(PM_address[5:4], grp);
	
//----------------------------------------------------------------------------
// Behavioral part of the code = memory subsystem "control unit"
//----------------------------------------------------------------------------

always @ (posedge c0) begin

	if (Resetn == 0) begin

//----------------------------------------------------------------------------
// Memory subsystem initialization; after a reset the cache content is
//    random, and thus the miss signal is set to 1; this in turn will trigger
//    the transfer of the first block from PM into the cache.
//----------------------------------------------------------------------------

		miss = 1'b1; transfer_count = 5'b0000;
	
		replace[0] = 4'h3; replace[1] = 4'h3; replace[2] = 4'h3; replace[3] = 4'h3;
		
		we_n0 = 1; we_n1 = 1; rd_n0 = 1; rd_n1 = 1;
		
	end else begin
	
		i = PM_address[6:5];
		
		StBusy = 0 ;
	
//----------------------------------------------------------------------------
// The HIT if statements
//----------------------------------------------------------------------------
// miss == 0 means we execute these statements under the assumption that we
//    have not yet discovered a miss.
//----------------------------------------------------------------------------
		if (miss == 0) begin
		
			we_n0 = 1; we_n1 = 1; we_n2 = 1; we_n3 = 1;
			
//----------------------------------------------------------------------------
// The condition logically ANDs each mbit with the coresponding group line;
// Then, all are logically OR-ed using the OR reduction operator.
//----------------------------------------------------------------------------

			if (|(mbits0 & grp)) begin
			
//----------------------------------------------------------------------------
// Concatenated group and word address fields.
//----------------------------------------------------------------------------

				PMC_address = {1'b0, PM_address[7:0]}; 

//----------------------------------------------------------------------------
// Apply the replacing strategy: if this block was accessed now and a 
//    replacement will be necessary next, replace the other block.
//----------------------------------------------------------------------------

			end else if (|(mbits1 & grp)) begin
			
//----------------------------------------------------------------------------
// Concatenated group and word address fields.
//----------------------------------------------------------------------------

				PMC_address = {1'b1, PM_address[7:0]}; 
				
//----------------------------------------------------------------------------
// Apply the replacing strategy: if this block was accessed now and a 
//    replacement will be necessary next, replace the other block.
//----------------------------------------------------------------------------

			end else	if (|(mbits2 & grp)) begin
			
//----------------------------------------------------------------------------
// Concatenated group and word address fields.
//----------------------------------------------------------------------------

				PMC_address = {1'b0, PM_address[7:0]}; 

//----------------------------------------------------------------------------
// Apply the replacing strategy: if this block was accessed now and a 
//    replacement will be necessary next, replace the other block.
//----------------------------------------------------------------------------
				
			end else	if (|(mbits3 & grp)) begin
			
//----------------------------------------------------------------------------
// Concatenated group and word address fields.
//----------------------------------------------------------------------------

				PMC_address = {1'b0, PM_address[7:0]}; 

//----------------------------------------------------------------------------
// Apply the replacing strategy: if this block was accessed now and a 
//    replacement will be necessary next, replace the other block.
//----------------------------------------------------------------------------

			end else begin 
//----------------------------------------------------------------------------
// A miss has been discovered, and thus the MISS statements are executed next
//----------------------------------------------------------------------------
					
				miss = 1'b1; transfer_count = 5'b00000;
				
			end
			
		end
		
//----------------------------------------------------------------------------
// The MISS if statements
//----------------------------------------------------------------------------

		if (miss == 1) begin
		
			replace[i] = (replace[i] + 1)%4 ;
		
			StBusy = 1 ;

//----------------------------------------------------------------------------
// The PMC_address is equal to the concatenation of the replace[i] bit, the 
//    group address field, and the word address; replace[i] is 0 or 1, and is
//    actually implementing a very simple replacement strategy: replace the 
//    block that was not used last of the two blocks in the cache.
//----------------------------------------------------------------------------

			PMC_address = {replace[i], PM_address[5:4], transfer_count[3:0]};
			
//----------------------------------------------------------------------------
// The PMM_address is equal to the entire address generated by the CPU
//----------------------------------------------------------------------------

			PMM_address = {PM_address[13:4], transfer_count[3:0]};
			
//----------------------------------------------------------------------------
// This wren enables the writing of the next word into the cache.
//----------------------------------------------------------------------------

			wren = 1'b1;
			
//----------------------------------------------------------------------------
// The word address is incremented by 1 to point to the next word in the block
//----------------------------------------------------------------------------

			transfer_count = transfer_count + 1'b1;
		
		end
			
//----------------------------------------------------------------------------
// At the end of a block transfer, update the CAMs
//----------------------------------------------------------------------------
		
		if (transfer_count == 5'b10001) begin
		
			miss = 0; wren = 0; transfer_count = 5'b00000;
			
				if (replace[i] == 0) begin

					din0 = {6'b0, PM_address[9:8]}; cam_addrs0 = PM_address[5:4];  we_n0 = 0;
				
				end if (replace[i] == 1) begin

					din1 = {6'b0, PM_address[13:6]}; cam_addrs1 = PM_address[5:4]; we_n0 = 0;
				
				end if (replace[i] == 2) begin

					din2 = {6'b0, PM_address[13:6]}; cam_addrs0 = PM_address[5:4]; we_n0 = 0;
				
				end else begin
				
					din3 = {6'b0, PM_address[13:6]}; cam_addrs1 = PM_address[5:4]; we_n1 = 0;
				
				end
		end
		
	end
	
end

endmodule
