// APB Interface Class
interface apb_interface #(int PADDR_SIZE = 32, int PDATA_SIZE = 32) (input bit clk, input bit rst);

	// PORT List
	logic			 PSEL;
	logic 			 PENABLE;
  	logic [PADDR_SIZE-1:0]   PADDR;
  	logic 			 PWRITE;
  	logic [PDATA_SIZE/8-1:0] PSTRB;
  	logic [PDATA_SIZE  -1:0] PWDATA;
  	logic [PDATA_SIZE  -1:0] PRDATA;
  	logic                    PREADY;
  	logic                    PSLVERR;
  	
  	// Declaration of Assertions
  	// Assert that PSEL is high during address phase
	property address_phase;
		@(posedge clk) (!rst) || (PSEL && !PENABLE);
	endproperty
	
	assert property (address_phase) else $error("Address phase violated: PSEL must be high before PENABLE.");
	
	// Assert that PENABLE is high only after PSEL is asserted
	property data_phase;
		@(posedge clk) (!rst) || (PSEL |=> PENABLE);
	endproperty
	
	assert property (data_phase) else $error("Data phase violated: PENABLE must be asserted after PSEL.");

	// Assert that PWRITE remains stable during a transaction
	property stable_pwrite;
		@(posedge clk) (!rst) || (PSEL && PENABLE |-> $stable(PWRITE));
	endproperty
	
	assert property (stable_pwrite) else $error("PWRITE changes during the transaction.");

	// Assert that PREADY and PENABLE are asserted only during an active transaction
	property transaction_ack;
  		@(posedge clk) (!rst) || ((PREADY && PENABLE) |-> PSEL);
	endproperty
	
	assert property (transaction_ack) else $error("PREADY and PENABLE asserted without an active transaction.");



  	// Wait Clk task
    	task automatic wait_clks(input int num);
    		repeat (num) @(posedge clk);
    	endtask
    
endinterface
