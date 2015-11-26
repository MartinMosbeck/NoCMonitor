`include "connect_parameter.v"


module testbench();
	parameter HalfClkPeriod = 5;
	parameter ClkPeriod = 2*HalfClkPeriod;

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

	wire PE0_EN;

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

	wire PE10_EN;

	// Generate Clock
	initial Clk = 0;
	always #(HalfClkPeriod) Clk = ~Clk;

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
	
		.PortID(PE0_recvPortID)
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
	
		.PortID(PE10_recvPortID)
	);

	
	mkNetwork dut
	(
		.CLK(clk),


		.RST_N(rst_n),
		.send_ports_0_putFlit_flit_in(PE0_flitToNet),
		.EN_send_ports_0_putFlit(PE0_sendFlit),
		.recv_ports_0_getFlit(PE0_enRecvFlit),
		.EN_recv_ports_0_getFlit(PE0_flitFromNet),
		.recv_ports_0_putCredits_cr_in(PE0_creditToNet),
		.EN_recv_ports_0_putCredits(PE0_sendCredit),
		.send_ports_0_getCredits(PE0_creditFromNet),
		.EN_send_ports_0_getCredits(PE0_enRecvCredit),
		.recv_ports_info_0_getRecvPortID(PE0_recvPortID),
	
		.send_ports_10_putFlit_flit_in(PE10_flitToNet),
		.EN_send_ports_10_putFlit(PE10_sendFlit),
		.recv_ports_10_getFlit(PE10_enRecvFlit),
		.EN_recv_ports_10_getFlit(PE10_flitFromNet),
		.recv_ports_10_putCredits_cr_in(PE10_creditToNet),
		.EN_recv_ports_10_putCredits(PE10_sendCredit),
		.send_ports_10_getCredits(PE10_creditFromNet),
		.EN_send_ports_10_getCredits(PE10_enRecvCredit),
		.recv_ports_info_10_getRecvPortID(PE10_recvPortID)
	);


endmodule



