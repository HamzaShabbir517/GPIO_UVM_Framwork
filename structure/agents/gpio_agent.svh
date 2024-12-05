// Include Defines
`include "gpio_defines.svh"

// Declare GPIO Agent
class gpio_agent extends uvm_agent;
	
	// Register it with factory
	`uvm_component_utils(gpio_agent)
	
	// Declaration of gpio agent config object
	gpio_agent_config gpio_cfg;
	
	// Declaration of Sequencer, Driver and Monitor
	// gpio_sequencer #(`NUM_PINS) gpio_sqr_h;
	uvm_sequencer #(gpio_sequence_item #(`NUM_PINS),gpio_sequence_item #(`NUM_PINS)) gpio_sqr_h;
	gpio_driver #(`NUM_PINS) gpio_drv_h;
	gpio_monitor #(`NUM_PINS) gpio_mon_h;
	
	// Declare Analysis Port
	uvm_analysis_port #(gpio_sequence_item #(`NUM_PINS)) gpio_ap;
	
	// New Constructor
	function new(string name = "gpio_agent", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Agent Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Agent Config object from data base
		if(!uvm_config_db #(gpio_agent_config)::get(this,"*","gpio_agent_config",gpio_cfg))
		`uvm_error("GPIO Agent Build_phase", "unable to get gpio_agent_config");
		
		// Check if Agent is active so build the driver and sequencer
		if(gpio_cfg.active == UVM_ACTIVE) begin
			//gpio_sqr_h = gpio_sequencer #(`NUM_PINS)::type_id::create("gpio_sqr_h",this);
			gpio_sqr_h = new("gpio_sqr_h",this);
			gpio_drv_h = gpio_driver #(`NUM_PINS)::type_id::create("gpio_drv_h",this);
		end
		
		// Build the monitor and analysis port
		gpio_mon_h = gpio_monitor #(`NUM_PINS)::type_id::create("gpio_mon_h",this);
		// Build the analysis port
		gpio_ap = new("gpio_ap", this);
		
	endfunction
	
	// Connect Phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// Connect Monitor Analysis port with Agent Analysis port
		gpio_mon_h.gpio_m_ap.connect(gpio_ap);
		// Pass the Virtual Interface to monitor
		gpio_mon_h.vif = gpio_cfg.gpio_if;
		
		// Check if Agent is active so connect the driver and sequencer
		if (gpio_cfg.active == UVM_ACTIVE) begin
			// Connection
			gpio_drv_h.seq_item_port.connect(gpio_sqr_h.seq_item_export);
			// Pass the Virtual interface to driver
			gpio_drv_h.vif = gpio_cfg.gpio_if; 
		end
	endfunction
endclass
