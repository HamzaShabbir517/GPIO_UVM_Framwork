// Include Defines
`include "apb_defines.svh"

// Declare APB Agent
class apb_agent extends uvm_agent;
	
	// Register is with factory
	`uvm_component_utils(apb_agent)
	
	// Declaration of Agent Config Object
	apb_agent_config apb_cfg;
	
	// Declaration of Sequencer, Driver and Monitor
	apb_sequencer apb_sqr_h;
	apb_driver #(`PADDR_SIZE, `PDATA_SIZE) apb_drv_h;
	apb_monitor #(`PADDR_SIZE, `PDATA_SIZE) apb_mon_h;
	
	// Declaration of Coverage Monitor
	apb_coverage_monitor apb_fcov_monitor;
	
	// Declare Analysis Port
	uvm_analysis_port #(apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE)) apb_agent_ap;
	
	// New Constructor
	function new(string name = "apb_agent", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Agent Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Agent Config object from data base using macro
		`get_config(apb_agent_config,apb_cfg,"apb_agent_config")
		
		// Check if Agent is active so build the driver and sequencer
		if(apb_cfg.active == UVM_ACTIVE) begin
			apb_sqr_h = apb_sequencer::type_id::create("apb_sqr_h",this);
			apb_drv_h = apb_driver #(`PADDR_SIZE, `PDATA_SIZE)::type_id::create("apb_drv_h",this);
		end
		
		// Build the monitor and analysis port
		apb_mon_h = apb_monitor #(`PADDR_SIZE, `PDATA_SIZE)::type_id::create("apb_mon_h",this);
		
		// Check if Functional Coverage Monitor is enable or not
		if(apb_cfg.has_functional_coverage) begin
			apb_fcov_monitor = apb_coverage_monitor::type_id::create("apb_fcov_monitor",this);
		end
			
		// Build the analysis port
		apb_agent_ap = new("apb_agent_ap", this);

	endfunction
	
	// Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// Connect Monitor Analysis port with Agent Analysis Port
		apb_mon_h.apb_m_ap.connect(apb_agent_ap);
		
		// Pass the Virtual Interface to monitor
		apb_mon_h.vif = apb_cfg.apb_if;
		
		// Check if Agent is active so connect the driver and sequencer
		if (apb_cfg.active == UVM_ACTIVE) begin
			// Connection
			apb_drv_h.seq_item_port.connect(apb_sqr_h.seq_item_export);
			// Pass the Virtual interface to driver
			apb_drv_h.vif = apb_cfg.apb_if; 
		end
		
		// Check if Functional Coverage is active so connect fifo with it
		if(apb_cfg.has_functional_coverage) begin
			apb_mon_h.apb_m_ap.connect(apb_fcov_monitor.analysis_export);
		end
		
	endfunction

endclass
