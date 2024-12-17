// Include Macros
`include "uvm_macros.svh"

// Declare GPIO Port Test
class gpio_port_test extends gpio_base_test;
	
	// Register it with factory
	`uvm_component_utils(gpio_port_test)
	
	// Declaration of config objects
	gpio_axi4l_env_config env_cfg;
	
	// Declaration of Sequence
	gpio_sequence gpio_seq;
	
	// New Constructor
	function new(string name = "gpio_port_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Environment Config from Data Base
		if (!uvm_config_db #(gpio_axi4l_env_config)::get(this, "*", "gpio_axi4l_env_config", env_cfg))
			`uvm_fatal("GPIO PORT TEST", "Environment configuration not found");
			
		env_cfg.has_gpio_agent = 1;
		env_cfg.gpio_agent_config_h.active = UVM_ACTIVE;
		
		// Set the Environment config back to data base
		uvm_config_db #(gpio_axi4l_env_config)::set(this,"*","gpio_axi4l_env_config",env_cfg);
	endfunction
	
	// Run task
	task run_phase(uvm_phase phase);
		
		// Create the Sequence
		gpio_seq = gpio_sequence::type_id::create("gpio_seq");
		
		// Raise the objection
		phase.raise_objection(this);
		
		// Start the Sequence
		gpio_seq.start(gpio_axi4l_env_h.gpio_agent_h.gpio_sqr_h);
		
		// Drop the objection
		phase.drop_objection(this);
	endtask
endclass
