// Include Macros
`include "uvm_macros.svh"

// Declare Virtual Sequence Test
class virt_seq_test extends gpio_base_test;
	
	// Register it with factory
	`uvm_component_utils(virt_seq_test)
	
	// Declaration of config objects
	gpio_env_config env_cfg;
	
	// Declaration of Sequence
	virtual_seq virt_seq;
	
	// New Constructor
	function new(string name = "virt_seq_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Environment Config from Data Base
		if (!uvm_config_db #(gpio_env_config)::get(this, "*", "gpio_env_config", env_cfg))
			`uvm_fatal("Virtual Sequence TEST", "Environment configuration not found");
			
		env_cfg.has_axi4l_agent = 1;
		env_cfg.has_gpio_agent = 1;
		
		// Set the Environment config back to data base
		uvm_config_db #(gpio_env_config)::set(this,"*","gpio_env_config",env_cfg);
		
	endfunction
	
	// Run task
	task run_phase(uvm_phase phase);
		
		// Create the Sequence
		virt_seq = virtual_seq::type_id::create("virt_seq");
		
		// Raise the objection
		phase.raise_objection(this);
		
		// Initialize the Sequencer with Virtual Sequencers
		init_vseq(virt_seq);
		// Start the Sequence
		virt_seq.start(null);
		
		// Drop the objection
		phase.drop_objection(this);
	endtask

endclass
