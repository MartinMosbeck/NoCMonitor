//TEMPLATE (%%...) parameter:
// CONNECTIONS
// CREATE_PEs
// MAPPINGS_mkNetwork

`include "connect_parameter.v"


module testbench();
	parameter HalfClkPeriod = 5;
	parameter ClkPeriod = 2*HalfClkPeriod;

	reg clk;
	reg rst_n;

	%%CONNECTIONS


	// Generate Clock
	initial Clk = 0;
	always #(HalfClkPeriod) Clk = ~Clk;

	%%CREATE_PEs

	
	mkNetwork dut
	(
		.CLK(clk),
                .RST_N(rst_n),
		
                %%MAPPINGS_mkNetwork
	);


endmodule



