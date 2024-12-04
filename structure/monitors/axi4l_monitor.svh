// Declaration of AXI4 Lite Monitor 
class axi4l_monitor #(int data_width = 32, int addr_width = 32) extends uvm_monitor;

	// Register it with factory
	`uvm_component_param_utils(axi4l_monitor #(data_width,addr_width))
	
	// AXI4 Lite Agent Config
	axi4l_agent_config axi4l_cfg;
	
	// Declaration of Virtual Interface
	virtual interface axi4l_interface #(addr_width,data_width) vif;
	
	// Declaration of Analysis ports
	uvm_analysis_port #(axi4l_sequence_item) axi4l_m_ap_w; // Write port
	uvm_analysis_port #(axi4l_sequence_item) axi4l_m_ap_r; // Read port
	
	// New Constructor
	function new(string name = "axi4l_monitor", uvm_component parent = null);
		super.new(name,parent);
	endfunction	
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the AXI4 Lite agent config from database
		// Get the config object from database
		if(!uvm_config_db #(axi4l_agent_config)::get(this,"*","axi4l_agent_config",axi4l_cfg))
		`uvm_fatal("AXI4 Lite Monitor Build_phase", "unable to get axi4l_agent_config");
		
		// Build the analysis port dynamically
		// Write port
		axi4l_m_ap_w = new("axi4l_m_ap_w", this, axi4l_sequence_item #(axi4l_cfg.data_width, axi4l_cfg.addr_width)::get_type());
		// Read port
		axi4l_m_ap_r = new("axi4l_m_ap_r", this, axi4l_sequence_item #(axi4l_cfg.data_width, axi4l_cfg.addr_width)::get_type());
		
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
		axi4l_sequence_item #(axi4l_cfg.data_width, axi4l_cfg.addr_width) axi4l_item;
		axi4l_item = axi4l_sequence_item #(axi4l_cfg.data_width, axi4l_cfg.addr_width)::type_id::create("axi4l_item", this);

		// Wait for posedge clk
		@(posedge vif.clk);
		// Check it the write transaction is initiated
		if (vif.AWVALID && vif.AWREADY) begin
			axi4l_item.addr = vif.AWADDR;
			axi4l_item.write = 1;

			// Wait for WVALID handshake
			@(posedge vif.clk);
			if (vif.WVALID && vif.WREADY) begin
				axi4l_item.wdata = vif.WDATA;
				axi4l_item.wstrb = vif.WSTRB;

				// Wait for BVALID handshake
				@(posedge vif.clk);
				if (vif.BVALID) begin
					axi4l_item.resp = vif.BRESP;
			
					// Write transaction complete, send via analysis port
					axi4l_m_ap_w.write(axi4l_item);
				end
			end
		end
	endtask
	
	// Monitor Read Channel
	task monitor_read_channel();
		axi4l_sequence_item #(axi4l_cfg.data_width, axi4l_cfg.addr_width) axi4l_item;
		axi4l_item = axi4l_sequence_item #(axi4l_cfg.data_width, axi4l_cfg.addr_width)::type_id::create("axi4l_item", this);

		// Wait for posedge clk
		@(posedge vif.clk);
		// Check it the read transaction is initiated
		if (vif.ARVALID && vif.ARREADY) begin
			axi4l_item.addr = vif.ARADDR;
			axi4l_item.write = 0;

			// Wait for RVALID handshake
			@(posedge vif.clk);
			if (vif.RVALID) begin
				axi4l_item.rdata = vif.RDATA;
				axi4l_item.resp = vif.RRESP;
				// Read transaction complete, send via analysis port
				axi4l_m_ap_r.write(axi4l_item);
			end
		end
	endtask

endclass
