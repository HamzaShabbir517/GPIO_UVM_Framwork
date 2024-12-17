// Include defines
`include "axi4l_defines.svh"

// Declaration of AXI4 Lite Driver
class axi4l_driver #(int data_width = 32, int addr_width = 32) extends uvm_driver #(axi4l_sequence_item #(`data_width,`addr_width));

	// Register it with factory
	`uvm_component_param_utils(axi4l_driver #(`data_width,`addr_width))
	
	// AXI4 Lite Agent Config
	axi4l_agent_config axi4l_cfg;
	
	// Declaration of Virtual Interface
	virtual interface axi4l_interface #(`addr_width,`data_width) vif;
	
	// New Constructor
	function new(string name = "axi4l_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the config object from database using macro
		`get_config(axi4l_agent_config,axi4l_cfg,"axi4l_agent_config")
	endfunction
	
	// Run Task
	task run_phase(uvm_phase phase);
		// Declaration of Sequence item
		axi4l_sequence_item #(`data_width,`addr_width) axi4l_seq;
		bit in_range;
		@(negedge vif.rst);
		forever begin
			axi4l_seq = axi4l_sequence_item #(`data_width,`addr_width)::type_id::create("axi4l_seq",this);
			// Get the next item
			seq_item_port.get_next_item(axi4l_seq);
			// Print the data
			`uvm_info("AXI4 Lite Driver Run Task %s",axi4l_seq.convert2string(),UVM_MEDIUM)
			in_range = addr_lookup(axi4l_seq.addr);
			if(in_range) begin
				// Drive the sequence to ports
				drive(axi4l_seq);
			end
			else begin
				`uvm_error("AXI4 Lite RUN", $sformatf("Access to addr %0h out of AXI4 Lite address range", axi4l_seq.addr))
			end
			// Item is done
			seq_item_port.item_done();
		end 
	endtask
	
	
	function bit addr_lookup(logic [`addr_width-1:0] address);
		if((address >= axi4l_cfg.start_address) && (address <= (axi4l_cfg.start_address + axi4l_cfg.range))) begin
			return 1;
		end
		else begin
			return 0;
		end
	endfunction
	
	task drive(axi4l_sequence_item #(`data_width,`addr_width) axi4l_item);
		// Timeout counter
		int unsigned cycle_count;
		
		// Reset all signals
		vif.AWVALID <= 0;
    		vif.WVALID <= 0;
    		vif.BREADY <= 0;
   		vif.ARVALID <= 0;
    		vif.RREADY <= 0;
    		
    		// Wait for posedge of clk
		@(posedge vif.clk);
		
		// Check if it is write transaction
		if(axi4l_item.write) begin
			// Start the Address Channel
			vif.AWVALID <= 1;
			vif.AWADDR <= axi4l_item.addr;
			
			// Wait for AWREADY with timeout
    			cycle_count = 0;
    			while (!vif.AWREADY && cycle_count < axi4l_cfg.timeout_cycles) begin
    				@(posedge vif.clk);
      				cycle_count++;
    			end

    			if (cycle_count == axi4l_cfg.timeout_cycles) begin
      				`uvm_error("AXI4L_WRITE_TIMEOUT", "AWREADY not asserted within timeout")
      				return;
    			end
    			
			// Wait for Posedge clk
			@(posedge vif.clk);
			vif.AWVALID <= 0;
			
			// Start the Write Data Channel
			vif.WVALID <= 1;
			vif.WDATA <= axi4l_item.data;
			vif.WSTRB <= axi4l_item.wstrb;
			
			// Wait for WREADY with timeout
    			cycle_count = 0;
    			while (!vif.WREADY && cycle_count < axi4l_cfg.timeout_cycles) begin
    				@(posedge vif.clk);
      				cycle_count++;
    			end

    			if (cycle_count == axi4l_cfg.timeout_cycles) begin
      				`uvm_error("AXI4L_WRITE_TIMEOUT", "WREADY not asserted within timeout")
      				return;
    			end
    			
			// Wait for Posedge clk
			@(posedge vif.clk);
			vif.WVALID <= 0;
			
			// Start the Write Response
    			cycle_count = 0;
    			while (!vif.BVALID && cycle_count < axi4l_cfg.timeout_cycles) begin
      				@(posedge vif.clk);
      				cycle_count++;
    			end

    			if (cycle_count == axi4l_cfg.timeout_cycles) begin
      				`uvm_error("AXI4L_WRITE_TIMEOUT", "BVALID not asserted within timeout")
      				return;
    			end
    			
			axi4l_item.resp <= vif.BRESP;
			// Wait for posedge
			@(posedge vif.clk);
			// Signal slave that response is accepted
			vif.BREADY <= 1;
			@(posedge vif.clk);
			vif.BREADY <= 0;
		end
		
		// if it is read transaction
		else begin
			// Start the address channel
			vif.ARVALID <= 1;
			vif.ARADDR <= axi4l_item.addr;
			 // Wait for ARREADY with timeout
    			cycle_count = 0;
    			while (!vif.ARREADY && cycle_count < axi4l_cfg.timeout_cycles) begin
      				@(posedge vif.clk);
      				cycle_count++;
    			end

    			if (cycle_count == axi4l_cfg.timeout_cycles) begin
      				`uvm_error("AXI4L_READ_TIMEOUT", "ARREADY not asserted within timeout")
      				return;
    			end
    			
			// Wait for Posedge clk
			@(posedge vif.clk);
			vif.ARVALID <= 0;
			
			// Start the Read Channel
    			cycle_count = 0;
    			while (!vif.RVALID && cycle_count < axi4l_cfg.timeout_cycles) begin
      				@(posedge vif.clk);
      				cycle_count++;
    			end

    			if (cycle_count == axi4l_cfg.timeout_cycles) begin
      				`uvm_error("AXI4L_READ_TIMEOUT", "RVALID not asserted within timeout")
      				return;
    			end
    			
			axi4l_item.data <= vif.RDATA;
			axi4l_item.resp <= vif.RRESP;
			// Wait for posedge
			@(posedge vif.clk);
			// Signal slave that data is accepted
			vif.RREADY <= 1;
			@(posedge vif.clk);
			vif.RREADY <= 0;
		end
		
		// Extra clock for synchronization
		 @(posedge vif.clk);
		
	endtask
endclass
