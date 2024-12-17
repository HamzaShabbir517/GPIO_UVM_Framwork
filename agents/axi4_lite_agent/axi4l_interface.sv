// AXI4 Lite Interface Class
interface axi4l_interface #(int addr_width = 32, int data_width = 32) (input bit clk, input bit rst);

	// Port list
	// Write Address Channel
	logic [addr_width-1:0] AWADDR;
    	logic AWVALID;
    	logic AWREADY;
    	
    	// Write data channel
    	logic [data_width-1:0] WDATA;
    	logic [data_width/8-1:0] WSTRB;
    	logic WVALID;
    	logic WREADY;
    	
    	// Write response channel
    	logic [1:0] BRESP;
    	logic BVALID;
    	logic BREADY;
    
   	// Read address channel
    	logic [addr_width-1:0] ARADDR;
    	logic ARVALID;
    	logic ARREADY;
    
    	// Read data channel
    	logic [data_width-1:0] RDATA;
    	logic [1:0] RRESP;
    	logic RVALID;
    	logic RREADY;
    	
    	// Assertions
    	property write_valid_ready_handshake;
    		@(posedge clk) (AWVALID && AWREADY) |-> ##3 (WVALID && WREADY);
    	endproperty
    	
    	assert property (write_valid_ready_handshake);
    	
    	property read_valid_ready_handshake;
    		@(posedge clk) (ARVALID && ARREADY) |-> ##3 (RVALID && RREADY);
    	endproperty
    	
    	assert property (read_valid_ready_handshake);
    	
    	property write_valid_stability;
    		@(posedge clk) (AWVALID && !AWREADY) |=> (AWVALID == $past(AWVALID));
    	endproperty
    	
    	// assert property (write_valid_stability);
    	
    	property read_valid_stability;
    		  @(posedge clk) (ARVALID && !ARREADY) |=> (ARVALID == $past(ARVALID));
    	endproperty
    	
    	// assert property (read_valid_stability);

	property write_address_alignment;
		@(posedge clk) AWVALID |-> (AWADDR[1:0] == 2'b00);
	endproperty
	
	assert property (write_address_alignment);
	
	property read_address_alignment;
		@(posedge clk) ARVALID |-> (ARADDR[1:0] == 2'b00);
	endproperty
	
	assert property (read_address_alignment);
	
	property read_write_exclusivity;
		@(posedge clk) !(ARVALID && AWVALID);
	endproperty
	
	// assert property (read_write_exclusivity);

	property read_valid_responses;
		@(posedge clk) RVALID |-> (RRESP == 2'b00 || RRESP == 2'b10);
	endproperty
	
	assert property (read_valid_responses);
	
	property write_valid_responses;
		@(posedge clk) BVALID |-> (BRESP == 2'b00 || BRESP == 2'b10);
	endproperty
	
	assert property (write_valid_responses);

	property write_strobe_check;
		@(posedge clk) (WVALID && WREADY) |-> (WSTRB != 4'b0000);
	endproperty
	
	assert property (write_strobe_check);

    	// Wait Clk task
    	task automatic wait_clks(input int num);
    		repeat (num) @(posedge clk);
    	endtask
	
endinterface
