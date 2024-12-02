// AXI4 Lite Interface Class
interface axi4l_interface #(int addr_width, int data_width) (input bit clk);

	// Port list
	logic rst;
	
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
    	
    	
    	// Wait Clk task
    	task automatic wait_clks(input int num);
    		repeat (num) @(posedge clk);
    	endtask
	
endinterface
