//TEMPLATE (%%...) parameter:
// CONNECTIONS
// CREATE_PEs
// MAPPINGS_mkNetwork

`include "connect_parameters.v"


module testbench();
	parameter HalfClkPeriod = 5;
	parameter ClkPeriod = 2*HalfClkPeriod;

	reg clk;
	reg rst_n;

        parameter vc_bits = (`NUM_VCS > 1) ? $clog2(`NUM_VCS) : 1;
	parameter dest_bits = $clog2(`NUM_USER_RECV_PORTS);
	parameter flit_port_width = 2 /*valid and tail bits*/+ `FLIT_DATA_WIDTH + dest_bits + vc_bits;
	parameter credit_port_width = 1 + vc_bits; // 1 valid bit
	parameter credit_cnt_width = $clog2(`FLIT_BUFFER_DEPTH + 1);

	        
        //Connection elements for PE_0        
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
        
        //Connection elements for PE_1        
        wire [flit_port_width-1:0] PE1_flitToNet;
        wire PE1_sendFlit;

        wire [flit_port_width-1:0] PE1_flitFromNet;
        wire PE1_enRecvFlit;

        wire [credit_port_width-1:0] PE1_creditToNet;
        wire PE1_sendCredit;

        wire [credit_port_width-1:0] PE1_creditFromNet;
        wire PE1_enRecvCredit;

        wire [dest_bits-1:0] PE1_recvPortID;

        reg PE1_EN;
        
        //Connection elements for PE_2        
        wire [flit_port_width-1:0] PE2_flitToNet;
        wire PE2_sendFlit;

        wire [flit_port_width-1:0] PE2_flitFromNet;
        wire PE2_enRecvFlit;

        wire [credit_port_width-1:0] PE2_creditToNet;
        wire PE2_sendCredit;

        wire [credit_port_width-1:0] PE2_creditFromNet;
        wire PE2_enRecvCredit;

        wire [dest_bits-1:0] PE2_recvPortID;

        reg PE2_EN;
        
        //Connection elements for PE_3        
        wire [flit_port_width-1:0] PE3_flitToNet;
        wire PE3_sendFlit;

        wire [flit_port_width-1:0] PE3_flitFromNet;
        wire PE3_enRecvFlit;

        wire [credit_port_width-1:0] PE3_creditToNet;
        wire PE3_sendCredit;

        wire [credit_port_width-1:0] PE3_creditFromNet;
        wire PE3_enRecvCredit;

        wire [dest_bits-1:0] PE3_recvPortID;

        reg PE3_EN;
        
        //Connection elements for PE_4        
        wire [flit_port_width-1:0] PE4_flitToNet;
        wire PE4_sendFlit;

        wire [flit_port_width-1:0] PE4_flitFromNet;
        wire PE4_enRecvFlit;

        wire [credit_port_width-1:0] PE4_creditToNet;
        wire PE4_sendCredit;

        wire [credit_port_width-1:0] PE4_creditFromNet;
        wire PE4_enRecvCredit;

        wire [dest_bits-1:0] PE4_recvPortID;

        reg PE4_EN;
        
        //Connection elements for PE_5        
        wire [flit_port_width-1:0] PE5_flitToNet;
        wire PE5_sendFlit;

        wire [flit_port_width-1:0] PE5_flitFromNet;
        wire PE5_enRecvFlit;

        wire [credit_port_width-1:0] PE5_creditToNet;
        wire PE5_sendCredit;

        wire [credit_port_width-1:0] PE5_creditFromNet;
        wire PE5_enRecvCredit;

        wire [dest_bits-1:0] PE5_recvPortID;

        reg PE5_EN;
        
        //Connection elements for PE_6        
        wire [flit_port_width-1:0] PE6_flitToNet;
        wire PE6_sendFlit;

        wire [flit_port_width-1:0] PE6_flitFromNet;
        wire PE6_enRecvFlit;

        wire [credit_port_width-1:0] PE6_creditToNet;
        wire PE6_sendCredit;

        wire [credit_port_width-1:0] PE6_creditFromNet;
        wire PE6_enRecvCredit;

        wire [dest_bits-1:0] PE6_recvPortID;

        reg PE6_EN;
        
        //Connection elements for PE_7        
        wire [flit_port_width-1:0] PE7_flitToNet;
        wire PE7_sendFlit;

        wire [flit_port_width-1:0] PE7_flitFromNet;
        wire PE7_enRecvFlit;

        wire [credit_port_width-1:0] PE7_creditToNet;
        wire PE7_sendCredit;

        wire [credit_port_width-1:0] PE7_creditFromNet;
        wire PE7_enRecvCredit;

        wire [dest_bits-1:0] PE7_recvPortID;

        reg PE7_EN;
        
        //Connection elements for PE_8        
        wire [flit_port_width-1:0] PE8_flitToNet;
        wire PE8_sendFlit;

        wire [flit_port_width-1:0] PE8_flitFromNet;
        wire PE8_enRecvFlit;

        wire [credit_port_width-1:0] PE8_creditToNet;
        wire PE8_sendCredit;

        wire [credit_port_width-1:0] PE8_creditFromNet;
        wire PE8_enRecvCredit;

        wire [dest_bits-1:0] PE8_recvPortID;

        reg PE8_EN;
        
        //Connection elements for PE_9        
        wire [flit_port_width-1:0] PE9_flitToNet;
        wire PE9_sendFlit;

        wire [flit_port_width-1:0] PE9_flitFromNet;
        wire PE9_enRecvFlit;

        wire [credit_port_width-1:0] PE9_creditToNet;
        wire PE9_sendCredit;

        wire [credit_port_width-1:0] PE9_creditFromNet;
        wire PE9_enRecvCredit;

        wire [dest_bits-1:0] PE9_recvPortID;

        reg PE9_EN;
        
        //Connection elements for PE_10        
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
        
        //Connection elements for PE_11        
        wire [flit_port_width-1:0] PE11_flitToNet;
        wire PE11_sendFlit;

        wire [flit_port_width-1:0] PE11_flitFromNet;
        wire PE11_enRecvFlit;

        wire [credit_port_width-1:0] PE11_creditToNet;
        wire PE11_sendCredit;

        wire [credit_port_width-1:0] PE11_creditFromNet;
        wire PE11_enRecvCredit;

        wire [dest_bits-1:0] PE11_recvPortID;

        reg PE11_EN;
        
        //Connection elements for PE_12        
        wire [flit_port_width-1:0] PE12_flitToNet;
        wire PE12_sendFlit;

        wire [flit_port_width-1:0] PE12_flitFromNet;
        wire PE12_enRecvFlit;

        wire [credit_port_width-1:0] PE12_creditToNet;
        wire PE12_sendCredit;

        wire [credit_port_width-1:0] PE12_creditFromNet;
        wire PE12_enRecvCredit;

        wire [dest_bits-1:0] PE12_recvPortID;

        reg PE12_EN;
        
        //Connection elements for PE_13        
        wire [flit_port_width-1:0] PE13_flitToNet;
        wire PE13_sendFlit;

        wire [flit_port_width-1:0] PE13_flitFromNet;
        wire PE13_enRecvFlit;

        wire [credit_port_width-1:0] PE13_creditToNet;
        wire PE13_sendCredit;

        wire [credit_port_width-1:0] PE13_creditFromNet;
        wire PE13_enRecvCredit;

        wire [dest_bits-1:0] PE13_recvPortID;

        reg PE13_EN;
        
        //Connection elements for PE_14        
        wire [flit_port_width-1:0] PE14_flitToNet;
        wire PE14_sendFlit;

        wire [flit_port_width-1:0] PE14_flitFromNet;
        wire PE14_enRecvFlit;

        wire [credit_port_width-1:0] PE14_creditToNet;
        wire PE14_sendCredit;

        wire [credit_port_width-1:0] PE14_creditFromNet;
        wire PE14_enRecvCredit;

        wire [dest_bits-1:0] PE14_recvPortID;

        reg PE14_EN;
        
        //Connection elements for PE_15        
        wire [flit_port_width-1:0] PE15_flitToNet;
        wire PE15_sendFlit;

        wire [flit_port_width-1:0] PE15_flitFromNet;
        wire PE15_enRecvFlit;

        wire [credit_port_width-1:0] PE15_creditToNet;
        wire PE15_sendCredit;

        wire [credit_port_width-1:0] PE15_creditFromNet;
        wire PE15_enRecvCredit;

        wire [dest_bits-1:0] PE15_recvPortID;

        reg PE15_EN;



	// Generate Clock
	initial clk = 0;
	always #(HalfClkPeriod) clk = ~clk;
    
//Perform reset and enable all    
        initial begin 
                $display("---- Performing Reset ----");
                rst_n = 0; // perform reset (active low) 
                #(5*ClkPeriod+HalfClkPeriod); 
                rst_n = 1; 
                #(HalfClkPeriod);

        //ENABLES
                                PE0_EN=0;
                PE1_EN=0;
                PE2_EN=0;
                PE3_EN=1;
                PE4_EN=0;
                PE5_EN=0;
                PE6_EN=0;
                PE7_EN=0;
                PE8_EN=0;
                PE9_EN=0;
                PE10_EN=0;
                PE11_EN=0;
                PE12_EN=1;
                PE13_EN=0;
                PE14_EN=0;
                PE15_EN=0;

        
        end

	        
        //PE_0 instantiation        
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
        
        //PE_1 instantiation        
        PE_1 pe1
        (
                .en(PE1_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE1_flitFromNet),
	        .flit_out(PE1_flitToNet),
	        .sendFlit(PE1_sendFlit),
	        .en_receiveFlit(PE1_enRecvFlit),

	        .credit_in(PE1_creditFromNet),
	        .credit_out(PE1_creditToNet),
	        .sendCredit(PE1_sendCredit),
	        .en_receiveCredit(PE1_enRecvCredit),
	
	        .recvPortID(PE1_recvPortID)
        );
        
        //PE_2 instantiation        
        PE_2 pe2
        (
                .en(PE2_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE2_flitFromNet),
	        .flit_out(PE2_flitToNet),
	        .sendFlit(PE2_sendFlit),
	        .en_receiveFlit(PE2_enRecvFlit),

	        .credit_in(PE2_creditFromNet),
	        .credit_out(PE2_creditToNet),
	        .sendCredit(PE2_sendCredit),
	        .en_receiveCredit(PE2_enRecvCredit),
	
	        .recvPortID(PE2_recvPortID)
        );
        
        //PE_3 instantiation        
        PE_3 pe3
        (
                .en(PE3_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE3_flitFromNet),
	        .flit_out(PE3_flitToNet),
	        .sendFlit(PE3_sendFlit),
	        .en_receiveFlit(PE3_enRecvFlit),

	        .credit_in(PE3_creditFromNet),
	        .credit_out(PE3_creditToNet),
	        .sendCredit(PE3_sendCredit),
	        .en_receiveCredit(PE3_enRecvCredit),
	
	        .recvPortID(PE3_recvPortID)
        );
        
        //PE_4 instantiation        
        PE_4 pe4
        (
                .en(PE4_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE4_flitFromNet),
	        .flit_out(PE4_flitToNet),
	        .sendFlit(PE4_sendFlit),
	        .en_receiveFlit(PE4_enRecvFlit),

	        .credit_in(PE4_creditFromNet),
	        .credit_out(PE4_creditToNet),
	        .sendCredit(PE4_sendCredit),
	        .en_receiveCredit(PE4_enRecvCredit),
	
	        .recvPortID(PE4_recvPortID)
        );
        
        //PE_5 instantiation        
        PE_5 pe5
        (
                .en(PE5_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE5_flitFromNet),
	        .flit_out(PE5_flitToNet),
	        .sendFlit(PE5_sendFlit),
	        .en_receiveFlit(PE5_enRecvFlit),

	        .credit_in(PE5_creditFromNet),
	        .credit_out(PE5_creditToNet),
	        .sendCredit(PE5_sendCredit),
	        .en_receiveCredit(PE5_enRecvCredit),
	
	        .recvPortID(PE5_recvPortID)
        );
        
        //PE_6 instantiation        
        PE_6 pe6
        (
                .en(PE6_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE6_flitFromNet),
	        .flit_out(PE6_flitToNet),
	        .sendFlit(PE6_sendFlit),
	        .en_receiveFlit(PE6_enRecvFlit),

	        .credit_in(PE6_creditFromNet),
	        .credit_out(PE6_creditToNet),
	        .sendCredit(PE6_sendCredit),
	        .en_receiveCredit(PE6_enRecvCredit),
	
	        .recvPortID(PE6_recvPortID)
        );
        
        //PE_7 instantiation        
        PE_7 pe7
        (
                .en(PE7_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE7_flitFromNet),
	        .flit_out(PE7_flitToNet),
	        .sendFlit(PE7_sendFlit),
	        .en_receiveFlit(PE7_enRecvFlit),

	        .credit_in(PE7_creditFromNet),
	        .credit_out(PE7_creditToNet),
	        .sendCredit(PE7_sendCredit),
	        .en_receiveCredit(PE7_enRecvCredit),
	
	        .recvPortID(PE7_recvPortID)
        );
        
        //PE_8 instantiation        
        PE_8 pe8
        (
                .en(PE8_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE8_flitFromNet),
	        .flit_out(PE8_flitToNet),
	        .sendFlit(PE8_sendFlit),
	        .en_receiveFlit(PE8_enRecvFlit),

	        .credit_in(PE8_creditFromNet),
	        .credit_out(PE8_creditToNet),
	        .sendCredit(PE8_sendCredit),
	        .en_receiveCredit(PE8_enRecvCredit),
	
	        .recvPortID(PE8_recvPortID)
        );
        
        //PE_9 instantiation        
        PE_9 pe9
        (
                .en(PE9_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE9_flitFromNet),
	        .flit_out(PE9_flitToNet),
	        .sendFlit(PE9_sendFlit),
	        .en_receiveFlit(PE9_enRecvFlit),

	        .credit_in(PE9_creditFromNet),
	        .credit_out(PE9_creditToNet),
	        .sendCredit(PE9_sendCredit),
	        .en_receiveCredit(PE9_enRecvCredit),
	
	        .recvPortID(PE9_recvPortID)
        );
        
        //PE_10 instantiation        
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
        
        //PE_11 instantiation        
        PE_11 pe11
        (
                .en(PE11_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE11_flitFromNet),
	        .flit_out(PE11_flitToNet),
	        .sendFlit(PE11_sendFlit),
	        .en_receiveFlit(PE11_enRecvFlit),

	        .credit_in(PE11_creditFromNet),
	        .credit_out(PE11_creditToNet),
	        .sendCredit(PE11_sendCredit),
	        .en_receiveCredit(PE11_enRecvCredit),
	
	        .recvPortID(PE11_recvPortID)
        );
        
        //PE_12 instantiation        
        PE_12 pe12
        (
                .en(PE12_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE12_flitFromNet),
	        .flit_out(PE12_flitToNet),
	        .sendFlit(PE12_sendFlit),
	        .en_receiveFlit(PE12_enRecvFlit),

	        .credit_in(PE12_creditFromNet),
	        .credit_out(PE12_creditToNet),
	        .sendCredit(PE12_sendCredit),
	        .en_receiveCredit(PE12_enRecvCredit),
	
	        .recvPortID(PE12_recvPortID)
        );
        
        //PE_13 instantiation        
        PE_13 pe13
        (
                .en(PE13_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE13_flitFromNet),
	        .flit_out(PE13_flitToNet),
	        .sendFlit(PE13_sendFlit),
	        .en_receiveFlit(PE13_enRecvFlit),

	        .credit_in(PE13_creditFromNet),
	        .credit_out(PE13_creditToNet),
	        .sendCredit(PE13_sendCredit),
	        .en_receiveCredit(PE13_enRecvCredit),
	
	        .recvPortID(PE13_recvPortID)
        );
        
        //PE_14 instantiation        
        PE_14 pe14
        (
                .en(PE14_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE14_flitFromNet),
	        .flit_out(PE14_flitToNet),
	        .sendFlit(PE14_sendFlit),
	        .en_receiveFlit(PE14_enRecvFlit),

	        .credit_in(PE14_creditFromNet),
	        .credit_out(PE14_creditToNet),
	        .sendCredit(PE14_sendCredit),
	        .en_receiveCredit(PE14_enRecvCredit),
	
	        .recvPortID(PE14_recvPortID)
        );
        
        //PE_15 instantiation        
        PE_15 pe15
        (
                .en(PE15_EN),        
	        .clk(clk),
	        .rst_n(rst_n),
	
	        .flit_in(PE15_flitFromNet),
	        .flit_out(PE15_flitToNet),
	        .sendFlit(PE15_sendFlit),
	        .en_receiveFlit(PE15_enRecvFlit),

	        .credit_in(PE15_creditFromNet),
	        .credit_out(PE15_creditToNet),
	        .sendCredit(PE15_sendCredit),
	        .en_receiveCredit(PE15_enRecvCredit),
	
	        .recvPortID(PE15_recvPortID)
        );


	
	mkNetwork dut
	(
		.CLK(clk),
                .RST_N(rst_n),
		
                                
                //Mappings for PE_0                
                .send_ports_0_putFlit_flit_in(PE0_flitToNet),
                .EN_send_ports_0_putFlit(PE0_sendFlit),
                .recv_ports_0_getFlit(PE0_flitFromNet), 
                .EN_recv_ports_0_getFlit(PE0_enRecvFlit),
                .recv_ports_0_putCredits_cr_in(PE0_creditToNet),
                .EN_recv_ports_0_putCredits(PE0_sendCredit),
                .send_ports_0_getCredits(PE0_creditFromNet),
                .EN_send_ports_0_getCredits(PE0_enRecvCredit),
                .recv_ports_info_0_getRecvPortID(PE0_recvPortID),                
                //Mappings for PE_1                
                .send_ports_1_putFlit_flit_in(PE1_flitToNet),
                .EN_send_ports_1_putFlit(PE1_sendFlit),
                .recv_ports_1_getFlit(PE1_flitFromNet), 
                .EN_recv_ports_1_getFlit(PE1_enRecvFlit),
                .recv_ports_1_putCredits_cr_in(PE1_creditToNet),
                .EN_recv_ports_1_putCredits(PE1_sendCredit),
                .send_ports_1_getCredits(PE1_creditFromNet),
                .EN_send_ports_1_getCredits(PE1_enRecvCredit),
                .recv_ports_info_1_getRecvPortID(PE1_recvPortID),                
                //Mappings for PE_2                
                .send_ports_2_putFlit_flit_in(PE2_flitToNet),
                .EN_send_ports_2_putFlit(PE2_sendFlit),
                .recv_ports_2_getFlit(PE2_flitFromNet), 
                .EN_recv_ports_2_getFlit(PE2_enRecvFlit),
                .recv_ports_2_putCredits_cr_in(PE2_creditToNet),
                .EN_recv_ports_2_putCredits(PE2_sendCredit),
                .send_ports_2_getCredits(PE2_creditFromNet),
                .EN_send_ports_2_getCredits(PE2_enRecvCredit),
                .recv_ports_info_2_getRecvPortID(PE2_recvPortID),                
                //Mappings for PE_3                
                .send_ports_3_putFlit_flit_in(PE3_flitToNet),
                .EN_send_ports_3_putFlit(PE3_sendFlit),
                .recv_ports_3_getFlit(PE3_flitFromNet), 
                .EN_recv_ports_3_getFlit(PE3_enRecvFlit),
                .recv_ports_3_putCredits_cr_in(PE3_creditToNet),
                .EN_recv_ports_3_putCredits(PE3_sendCredit),
                .send_ports_3_getCredits(PE3_creditFromNet),
                .EN_send_ports_3_getCredits(PE3_enRecvCredit),
                .recv_ports_info_3_getRecvPortID(PE3_recvPortID),                
                //Mappings for PE_4                
                .send_ports_4_putFlit_flit_in(PE4_flitToNet),
                .EN_send_ports_4_putFlit(PE4_sendFlit),
                .recv_ports_4_getFlit(PE4_flitFromNet), 
                .EN_recv_ports_4_getFlit(PE4_enRecvFlit),
                .recv_ports_4_putCredits_cr_in(PE4_creditToNet),
                .EN_recv_ports_4_putCredits(PE4_sendCredit),
                .send_ports_4_getCredits(PE4_creditFromNet),
                .EN_send_ports_4_getCredits(PE4_enRecvCredit),
                .recv_ports_info_4_getRecvPortID(PE4_recvPortID),                
                //Mappings for PE_5                
                .send_ports_5_putFlit_flit_in(PE5_flitToNet),
                .EN_send_ports_5_putFlit(PE5_sendFlit),
                .recv_ports_5_getFlit(PE5_flitFromNet), 
                .EN_recv_ports_5_getFlit(PE5_enRecvFlit),
                .recv_ports_5_putCredits_cr_in(PE5_creditToNet),
                .EN_recv_ports_5_putCredits(PE5_sendCredit),
                .send_ports_5_getCredits(PE5_creditFromNet),
                .EN_send_ports_5_getCredits(PE5_enRecvCredit),
                .recv_ports_info_5_getRecvPortID(PE5_recvPortID),                
                //Mappings for PE_6                
                .send_ports_6_putFlit_flit_in(PE6_flitToNet),
                .EN_send_ports_6_putFlit(PE6_sendFlit),
                .recv_ports_6_getFlit(PE6_flitFromNet), 
                .EN_recv_ports_6_getFlit(PE6_enRecvFlit),
                .recv_ports_6_putCredits_cr_in(PE6_creditToNet),
                .EN_recv_ports_6_putCredits(PE6_sendCredit),
                .send_ports_6_getCredits(PE6_creditFromNet),
                .EN_send_ports_6_getCredits(PE6_enRecvCredit),
                .recv_ports_info_6_getRecvPortID(PE6_recvPortID),                
                //Mappings for PE_7                
                .send_ports_7_putFlit_flit_in(PE7_flitToNet),
                .EN_send_ports_7_putFlit(PE7_sendFlit),
                .recv_ports_7_getFlit(PE7_flitFromNet), 
                .EN_recv_ports_7_getFlit(PE7_enRecvFlit),
                .recv_ports_7_putCredits_cr_in(PE7_creditToNet),
                .EN_recv_ports_7_putCredits(PE7_sendCredit),
                .send_ports_7_getCredits(PE7_creditFromNet),
                .EN_send_ports_7_getCredits(PE7_enRecvCredit),
                .recv_ports_info_7_getRecvPortID(PE7_recvPortID),                
                //Mappings for PE_8                
                .send_ports_8_putFlit_flit_in(PE8_flitToNet),
                .EN_send_ports_8_putFlit(PE8_sendFlit),
                .recv_ports_8_getFlit(PE8_flitFromNet), 
                .EN_recv_ports_8_getFlit(PE8_enRecvFlit),
                .recv_ports_8_putCredits_cr_in(PE8_creditToNet),
                .EN_recv_ports_8_putCredits(PE8_sendCredit),
                .send_ports_8_getCredits(PE8_creditFromNet),
                .EN_send_ports_8_getCredits(PE8_enRecvCredit),
                .recv_ports_info_8_getRecvPortID(PE8_recvPortID),                
                //Mappings for PE_9                
                .send_ports_9_putFlit_flit_in(PE9_flitToNet),
                .EN_send_ports_9_putFlit(PE9_sendFlit),
                .recv_ports_9_getFlit(PE9_flitFromNet), 
                .EN_recv_ports_9_getFlit(PE9_enRecvFlit),
                .recv_ports_9_putCredits_cr_in(PE9_creditToNet),
                .EN_recv_ports_9_putCredits(PE9_sendCredit),
                .send_ports_9_getCredits(PE9_creditFromNet),
                .EN_send_ports_9_getCredits(PE9_enRecvCredit),
                .recv_ports_info_9_getRecvPortID(PE9_recvPortID),                
                //Mappings for PE_10                
                .send_ports_10_putFlit_flit_in(PE10_flitToNet),
                .EN_send_ports_10_putFlit(PE10_sendFlit),
                .recv_ports_10_getFlit(PE10_flitFromNet), 
                .EN_recv_ports_10_getFlit(PE10_enRecvFlit),
                .recv_ports_10_putCredits_cr_in(PE10_creditToNet),
                .EN_recv_ports_10_putCredits(PE10_sendCredit),
                .send_ports_10_getCredits(PE10_creditFromNet),
                .EN_send_ports_10_getCredits(PE10_enRecvCredit),
                .recv_ports_info_10_getRecvPortID(PE10_recvPortID),                
                //Mappings for PE_11                
                .send_ports_11_putFlit_flit_in(PE11_flitToNet),
                .EN_send_ports_11_putFlit(PE11_sendFlit),
                .recv_ports_11_getFlit(PE11_flitFromNet), 
                .EN_recv_ports_11_getFlit(PE11_enRecvFlit),
                .recv_ports_11_putCredits_cr_in(PE11_creditToNet),
                .EN_recv_ports_11_putCredits(PE11_sendCredit),
                .send_ports_11_getCredits(PE11_creditFromNet),
                .EN_send_ports_11_getCredits(PE11_enRecvCredit),
                .recv_ports_info_11_getRecvPortID(PE11_recvPortID),                
                //Mappings for PE_12                
                .send_ports_12_putFlit_flit_in(PE12_flitToNet),
                .EN_send_ports_12_putFlit(PE12_sendFlit),
                .recv_ports_12_getFlit(PE12_flitFromNet), 
                .EN_recv_ports_12_getFlit(PE12_enRecvFlit),
                .recv_ports_12_putCredits_cr_in(PE12_creditToNet),
                .EN_recv_ports_12_putCredits(PE12_sendCredit),
                .send_ports_12_getCredits(PE12_creditFromNet),
                .EN_send_ports_12_getCredits(PE12_enRecvCredit),
                .recv_ports_info_12_getRecvPortID(PE12_recvPortID),                
                //Mappings for PE_13                
                .send_ports_13_putFlit_flit_in(PE13_flitToNet),
                .EN_send_ports_13_putFlit(PE13_sendFlit),
                .recv_ports_13_getFlit(PE13_flitFromNet), 
                .EN_recv_ports_13_getFlit(PE13_enRecvFlit),
                .recv_ports_13_putCredits_cr_in(PE13_creditToNet),
                .EN_recv_ports_13_putCredits(PE13_sendCredit),
                .send_ports_13_getCredits(PE13_creditFromNet),
                .EN_send_ports_13_getCredits(PE13_enRecvCredit),
                .recv_ports_info_13_getRecvPortID(PE13_recvPortID),                
                //Mappings for PE_14                
                .send_ports_14_putFlit_flit_in(PE14_flitToNet),
                .EN_send_ports_14_putFlit(PE14_sendFlit),
                .recv_ports_14_getFlit(PE14_flitFromNet), 
                .EN_recv_ports_14_getFlit(PE14_enRecvFlit),
                .recv_ports_14_putCredits_cr_in(PE14_creditToNet),
                .EN_recv_ports_14_putCredits(PE14_sendCredit),
                .send_ports_14_getCredits(PE14_creditFromNet),
                .EN_send_ports_14_getCredits(PE14_enRecvCredit),
                .recv_ports_info_14_getRecvPortID(PE14_recvPortID),                
                //Mappings for PE_15                
                .send_ports_15_putFlit_flit_in(PE15_flitToNet),
                .EN_send_ports_15_putFlit(PE15_sendFlit),
                .recv_ports_15_getFlit(PE15_flitFromNet), 
                .EN_recv_ports_15_getFlit(PE15_enRecvFlit),
                .recv_ports_15_putCredits_cr_in(PE15_creditToNet),
                .EN_recv_ports_15_putCredits(PE15_sendCredit),
                .send_ports_15_getCredits(PE15_creditFromNet),
                .EN_send_ports_15_getCredits(PE15_enRecvCredit),
                .recv_ports_info_15_getRecvPortID(PE15_recvPortID)
	);


endmodule


