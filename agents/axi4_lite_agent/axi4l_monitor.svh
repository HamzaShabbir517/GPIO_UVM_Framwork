// Include Defines
`include "axi4l_defines.svh"

// Declaration of AXI4 Lite Monitor 
class axi4l_monitor #(int data_width = 32, int addr_width = 32) extends uvm_monitor;

	// Register it with factory
	`uvm_component_param_utils(axi4l_monitor #(`data_width,`addr_width))
	
	// AXI4 Lite Agent Config
	axi4l_agent_config axi4l_cfg;
	
	// Declaration of Virtual Interface
	virtual interface axi4l_interface #(`addr_width,`data_width) vif;
	
	// Declaration of Analysis ports
	uvm_analysis_port #(axi4l_sequence_item #(`addr_width,`data_width)) axi4l_m_ap; // Analysis port
	
	// New Constructor
	function new(string name = "axi4l_monitor", uvm_component parent = null);
		super.new(name,parent);
	endfunction	
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the AXI4 Lite agent config from database using macro
		`get_config(axi4l_agent_config,axi4l_cfg,"axi4l_agent_config")
		
		// Build the analysis port
		// Analysis port
		axi4l_m_ap = new("axi4l_m_ap", this);
		
	endfunction
	
	// Run Phase
	task run_phase(uvm_phase phase);
		// Wait for reset to complete
		@(negedge vif.rst);
		
        	forever begin
            		monitor_write_channel();
            		monitor_read_channel();
        	end
    	endtask
    	
    	
	// Monitor Write Channel
	task monitor_write_channel();
		axi4l_sequence_item #(`data_width, `addr_width) axi4l_item, axi4l_item_clone;
		axi4l_item = axi4l_sequence_item #(`data_width, `addr_width)::type_id::create("axi4l_item", this);

		// Check it the write transaction is initiated
		if (vif.AWVALID && vif.AWREADY) begin
			axi4l_item.addr = vif.AWADDR;
			axi4l_item.write = 1;

			// Wait for WVALID handshake
			vif.wait_clks(3);
			if (vif.WVALID && vif.WREADY) begin
				axi4l_item.data = vif.WDATA;
				axi4l_item.wstrb = vif.WSTRB;

				// Wait for BVALID handshake
				vif.wait_clks(3);
				if (vif.BVALID) begin
					`uvm_info("AXI4 Lite Monitor","Write Response Receive",UVM_MEDIUM)
					axi4l_item.resp = vif.BRESP;
					// Create a copy of the transaction object using clone()
					$cast(axi4l_item_clone, axi4l_item.clone()); 
					// Write transaction complete, send via analysis port
					axi4l_m_ap.write(axi4l_item_clone);
				end
			end
		end
	endtask
	
	// Monitor Read Channel
	task monitor_read_channel();
		axi4l_sequence_item #(`data_width, `addr_width) axi4l_item, axi4l_item_clone;
		axi4l_item = axi4l_sequence_item #(`data_width, `addr_width)::type_id::create("axi4l_item", this);

		// Wait for posedge clk
		@(posedge vif.clk);
		// Check it the read transaction is initiated
		if (vif.ARVALID && vif.ARREADY) begin
			axi4l_item.addr = vif.ARADDR;
			axi4l_item.write = 0;

			// Wait for RVALID handshake
			@(posedge vif.clk);
			if (vif.RVALID) begin
				`uvm_info("AXI4 Lite Monitor","Read Response Receive",UVM_MEDIUM)
				axi4l_item.data = vif.RDATA;
				axi4l_item.resp = vif.RRESP;
				// Create a copy of the transaction object using clone()
				$cast(axi4l_item_clone, axi4l_item.clone()); 
				// Read transaction complete, send via analysis port
				axi4l_m_ap.write(axi4l_item_clone);
			end
		end
	endtask

endclass
