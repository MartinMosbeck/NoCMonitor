`include "connect_parameters.v"

module PE_0
(
	en,        
	clk,
	rst_n,
	
	flit_in,
	flit_out,
	sendFlit,
	en_receiveFlit,

	credit_in,
	credit_out,
	sendCredit,
	en_receiveCredit,
	
	recvPortID
);


//################### 
//#LOCAL PARAMETERS # 
//###################

	parameter vc_bits = (`NUM_VCS > 1) ? $clog2(`NUM_VCS) : 1;
	parameter dest_bits = $clog2(`NUM_USER_RECV_PORTS);
	parameter flit_port_width = 2 /*valid and tail bits*/+ `FLIT_DATA_WIDTH + dest_bits + vc_bits;
	parameter credit_port_width = 1 + vc_bits; // 1 valid bit
	parameter credit_cnt_width = $clog2(`FLIT_BUFFER_DEPTH + 1);

//#################
//# PORTS + TYPES #
//#################

	/* enable, clock, reset */
	input en;	
	wire  en;
	input clk;	
	wire  clk; 
	input rst_n;	
	wire  rst_n;

	/* flit handling */
	input  [flit_port_width-1:0] flit_in;	
	wire   [flit_port_width-1:0] flit_in;
	output [flit_port_width-1:0] flit_out;
	reg    [flit_port_width-1:0] flit_out;
	output sendFlit;
	reg    sendFlit;
	output en_receiveFlit;
	reg    en_receiveFlit;

	/* credit handling*/
	input  [credit_port_width-1:0] credit_in;
	wire   [credit_port_width-1:0] credit_in;
	output [credit_port_width-1:0] credit_out;
	reg    [credit_port_width-1:0] credit_out;
	output sendCredit;
	reg    sendCredit;
	output en_receiveCredit;
	reg    en_receiveCredit;

	/* receive port id */
	input [dest_bits-1:0] recvPortID;
	wire  [dest_bits-1:0] recvPortID;

//####################################
//# FLOW CONTROL BUFFERS &  COUNTERS #
//####################################
	reg [credit_cnt_width -1 : 0] cnt_credit [0 : `NUM_VCS -1];
	//QUESTION: flit_buffer?

//#########################
//# SENDING FLITS CONTROL #
//#########################
	reg [31 : 0] cnt_cycle;
	// packet fields
	reg is_valid;
	reg is_tail;
	reg [dest_bits-1:0] dest;
	reg [vc_bits-1:0]   vc;
	reg [`FLIT_DATA_WIDTH-1:0] data;

        integer i;

        reg [`FLIT_DATA_WIDTH-1:0] data_buf [12:0];
        reg [4:0] data_index;

always @ (posedge clk or negedge rst_n)
begin
	if(en == 1)
	begin	
		if (~rst_n)
		begin
			en_receiveFlit = 1;
			en_receiveCredit = 1;
		
			for(i=0; i < `NUM_VCS; i = i + 1) 
				cnt_credit[i] = `FLIT_BUFFER_DEPTH;
		
			cnt_cycle = 0;
			sendFlit = 0;
                        flit_out = 0;
			sendCredit = 0;
                        credit_out = 0;
                        data_index = 0;

                        data_buf [0]='hdead0;
                        data_buf [1]='hdead1;
                        data_buf [2]='hdead2;
                        data_buf [3]='hdead3;
                        data_buf [4]='hdead4;
                        data_buf [5]='hdead5;
                        data_buf [6]='hdead6;
                        data_buf [7]='hdead7;
                        data_buf [8]='hdead8;
                        data_buf [9]='hdead9;
                        data_buf [10]='hdead10;
                        data_buf [11]='hdead11;
                        data_buf [12]='hdead12;
	
	
		end
		else
		begin
			cnt_cycle = cnt_cycle + 1;
			sendFlit = 0;
			sendCredit = 0;
                        flit_out=0;
                        credit_out=0;
			//receive a flit
			if (flit_in[flit_port_width-1] == 1) //flit is valid
			begin
				$display("PE(0) @%3d: Flit '%0x' received", cnt_cycle, flit_in[63:0]);
			end	

                        //receive a credit
                        if (credit_in[credit_port_width-1] == 1)
                        begin
                                vc = credit_in[credit_port_width-2 : 0];
                                cnt_credit[vc]=cnt_credit[vc]+1;
                                $display("PE(0) @%3d: Received credit for vc%0d",cnt_cycle, vc);
                                $display("PE(0) @%3d: Credit for for vc%0d now at %0d",cnt_cycle, vc,cnt_credit[vc] );
                                
                        
                        end			

			//send a flit
			if(cnt_cycle%10 == 0)
			begin
				dest = 10;
				vc = 0;
				data = data_buf[data_index];
				flit_out = {1'b1 /*valid*/, 1'b0 /*tail*/, dest, vc, data};
				sendFlit = 1;
				$display("PE(0) @%3d: Flit '%0x' sent", cnt_cycle, flit_out[63:0]);
                                data_index = data_index + 1;
               
                                cnt_credit[vc] = cnt_credit[vc]-1;
                                $display("PE(0) @%3d: Consumed credit for vc%0d",cnt_cycle, vc);
                                $display("PE(0) @%3d: Credit for for vc%0d now at %0d",cnt_cycle, vc,cnt_credit[vc] );

			end
				
		
		end	
	end
end				
		
endmodule
