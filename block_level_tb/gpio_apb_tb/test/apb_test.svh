// Include Macros
`include "uvm_macros.svh"

// Declare APB Test
class apb_test extends gpio_base_test;
	
	// Register it with factory
	`uvm_component_utils(apb_test)
	
	// Declaration of config objects
	gpio_apb_env_config env_cfg;
	
	// Declaration of Sequence
	apb_sequence apb_seq;
	
	// New Constructor
	function new(string name = "apb_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Environment Config from Data Base
		if (!uvm_config_db #(gpio_apb_env_config)::get(this, "*", "gpio_apb_env_config", env_cfg))
			`uvm_fatal("APB TEST", "Environment configuration not found");
			
		env_cfg.has_apb_agent = 1;
		env_cfg.apb_agent_config_h.active = UVM_ACTIVE;
		
		// Set the Environment config back to data base
		uvm_config_db #(gpio_apb_env_config)::set(this,"*","gpio_apb_env_config",env_cfg);
	endfunction
	
	// Run task
	task run_phase(uvm_phase phase);
		
		// Create the Sequence
		apb_seq = apb_sequence::type_id::create("apb_seq");
		
		// Raise the objection
		phase.raise_objection(this);
		
		// Start the Sequence
		apb_seq.start(gpio_apb_env_h.apb_agent_h.apb_sqr_h);
		
		// Drop the objection
		phase.drop_objection(this);
	endtask
endclass
