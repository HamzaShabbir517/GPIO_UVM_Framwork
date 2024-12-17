// Include Defines
`include "axi4l_defines.svh"

// Declare AXI4 Lite Agent
class axi4l_agent extends uvm_agent;
	
	// Register is with factory
	`uvm_component_utils(axi4l_agent)
	
	// Declaration of Agent Config Object
	axi4l_agent_config axi4l_cfg;
	
	// Declaration of Sequencer, Driver and Monitor
	axi4l_sequencer axi4l_sqr_h;
	axi4l_driver #(`data_width,`addr_width) axi4l_drv_h;
	axi4l_monitor #(`data_width,`addr_width) axi4l_mon_h;
	
	// Declaration of Coverage Monitor
	axi4l_coverage_monitor axi4l_fcov_monitor;
	
	// Declare Analysis Port
	uvm_analysis_port #(axi4l_sequence_item #(`data_width,`addr_width)) axi4l_agent_ap;
	
	// New Constructor
	function new(string name = "axi4l_agent", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Agent Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Agent Config object from data base using macro
		`get_config(axi4l_agent_config,axi4l_cfg,"axi4l_agent_config")
		
		// Check if Agent is active so build the driver and sequencer
		if(axi4l_cfg.active == UVM_ACTIVE) begin
			axi4l_sqr_h = axi4l_sequencer::type_id::create("axi4l_sqr_h",this);
			axi4l_drv_h = axi4l_driver #(`data_width,`addr_width)::type_id::create("axi4l_drv_h",this);
		end
		
		// Build the monitor and analysis port
		axi4l_mon_h = axi4l_monitor #(`data_width,`addr_width)::type_id::create("axi4l_mon_h",this);
		
		// Check if Functional Coverage Monitor is enable or not
		if(axi4l_cfg.has_functional_coverage) begin
			axi4l_fcov_monitor = axi4l_coverage_monitor::type_id::create("axi4l_fcov_monitor",this);
		end
			
		// Build the analysis port
		axi4l_agent_ap = new("axi4l_agent_ap", this);

	endfunction
	
	// Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// Connect Monitor Analysis port with Agent
		axi4l_mon_h.axi4l_m_ap.connect(axi4l_agent_ap);
		
		// Pass the Virtual Interface to monitor
		axi4l_mon_h.vif = axi4l_cfg.axi4l_if;
		
		// Check if Agent is active so connect the driver and sequencer
		if (axi4l_cfg.active == UVM_ACTIVE) begin
			// Connection
			axi4l_drv_h.seq_item_port.connect(axi4l_sqr_h.seq_item_export);
			// Pass the Virtual interface to driver
			axi4l_drv_h.vif = axi4l_cfg.axi4l_if; 
		end
		
		// Check if Functional Coverage is active so connect fifo with it
		if(axi4l_cfg.has_functional_coverage) begin
			axi4l_mon_h.axi4l_m_ap.connect(axi4l_fcov_monitor.analysis_export);
		end
		
	endfunction
endclass
