`include "connect_parameters.v"


module testbench();
	parameter HalfClkPeriod = 5;
	localparam ClkPeriod = 2*HalfClkPeriod;

	localparam vc_bits = (`NUM_VCS > 1) ? $clog2(`NUM_VCS) : 1;
	localparam dest_bits = $clog2(`NUM_USER_RECV_PORTS);
	localparam flit_port_width = 2 /*valid and tail bits*/+ `FLIT_DATA_WIDTH + dest_bits + vc_bits;
	localparam credit_port_width = 1 + vc_bits; // 1 valid bit
	localparam credit_cnt_width = $clog2(`FLIT_BUFFER_DEPTH + 1);

	reg clk;
	reg rst_n;

	//wires for PE0
	wire [flit_port_width-1:0] PE0_flitToNet;
	wire PE0_sendFlit;

	wire [flit_port_width-1:0] PE0_flitFromNet;
	wire PE0_enRecvFlit;

	wire [credit_port_width-1:0] PE0_creditToNet;
	wire PE0_sendCredit;

	wire [credit_port_width-1:0] PE0_creditFromNet;
	wire PE0_enRecvCredit;

	wire [dest_bits-1:0] PE0_recvPortID;

	reg PE0_EN;

	//wires for PE10
	wire [flit_port_width-1:0] PE10_flitToNet;
	wire PE10_sendFlit;

	wire [flit_port_width-1:0] PE10_flitFromNet;
	wire PE10_enRecvFlit;

	wire [credit_port_width-1:0] PE10_creditToNet;
	wire PE10_sendCredit;

	wire [credit_port_width-1:0] PE10_creditFromNet;
	wire PE10_enRecvCredit;

	wire [dest_bits-1:0] PE10_recvPortID;

	reg PE10_EN;

	
	reg [31:0] cnt_cycle;

	// Generate Clock
	initial clk = 0;
	always #(HalfClkPeriod) clk = ~clk;

	initial 
	begin 
		cnt_cycle = 0;

		PE0_EN = 1;
		PE10_EN = 1;

		$display("---- Performing Reset ----");
		rst_n = 0; // perform reset (active low) 
		#(5*ClkPeriod+HalfClkPeriod); 
		rst_n = 1; 
		#(HalfClkPeriod);

	end


	// terminate sim
	always @ (posedge clk) 
	begin
		cnt_cycle <= cnt_cycle + 1;
		// terminate simulation
		if (cnt_cycle > 150) begin
			$finish();
		end
	end

	//PE_0	
	PE_0 pe0
	(
		.en(PE0_EN),        
		.clk(clk),
		.rst_n(rst_n),
	
		.flit_in(PE0_flitFromNet),
		.flit_out(PE0_flitToNet),
		.sendFlit(PE0_sendFlit),
		.en_receiveFlit(PE0_enRecvFlit),
	
		.credit_in(PE0_creditFromNet),
		.credit_out(PE0_creditToNet),
		.sendCredit(PE0_sendCredit),
		.en_receiveCredit(PE0_enRecvCredit),
	
		.recvPortID(PE0_recvPortID)
	);
	
	//PE_10
	PE_10 pe10
	(
		.en(PE10_EN),        
		.clk(clk),
		.rst_n(rst_n),
	
		.flit_in(PE10_flitFromNet),
		.flit_out(PE10_flitToNet),
		.sendFlit(PE10_sendFlit),
		.en_receiveFlit(PE10_enRecvFlit),
	
		.credit_in(PE10_creditFromNet),
		.credit_out(PE10_creditToNet),
		.sendCredit(PE10_sendCredit),
		.en_receiveCredit(PE10_enRecvCredit),
	
		.recvPortID(PE10_recvPortID)
	);

	
	mkNetwork dut
	(
		.CLK(clk),
                .RST_N(rst_n),

		.send_ports_0_putFlit_flit_in(PE0_flitToNet),
		.EN_send_ports_0_putFlit(PE0_sendFlit),
		.recv_ports_0_getFlit(PE0_flitFromNet),
		.EN_recv_ports_0_getFlit(PE0_enRecvFlit ),
		.recv_ports_0_putCredits_cr_in(PE0_creditToNet),
		.EN_recv_ports_0_putCredits(PE0_sendCredit),
		.send_ports_0_getCredits(PE0_creditFromNet),
		.EN_send_ports_0_getCredits(PE0_enRecvCredit),
		.recv_ports_info_0_getRecvPortID(PE0_recvPortID),
	
		.send_ports_10_putFlit_flit_in(PE10_flitToNet),
		.EN_send_ports_10_putFlit(PE10_sendFlit),
		.recv_ports_10_getFlit(PE10_flitFromNet),
		.EN_recv_ports_10_getFlit(PE10_enRecvFlit),
		.recv_ports_10_putCredits_cr_in(PE10_creditToNet),
		.EN_recv_ports_10_putCredits(PE10_sendCredit),
		.send_ports_10_getCredits(PE10_creditFromNet),
		.EN_send_ports_10_getCredits(PE10_enRecvCredit),
		.recv_ports_info_10_getRecvPortID(PE10_recvPortID)
	);


endmodule



