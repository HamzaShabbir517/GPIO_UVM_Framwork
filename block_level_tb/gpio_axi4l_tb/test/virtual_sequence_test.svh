// Include Macros
`include "uvm_macros.svh"

// Declare Virtual Sequence Test
class virt_seq_test extends gpio_base_test;
	
	// Register it with factory
	`uvm_component_utils(virt_seq_test)
	
	// Declaration of config objects
	gpio_axi4l_env_config env_cfg;
	
	// Declaration of Sequence
	basic_test_vseq vseq_1;
	reg_test_vseq vseq_2;
	
	// New Constructor
	function new(string name = "virt_seq_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Environment Config from Data Base
		if (!uvm_config_db #(gpio_axi4l_env_config)::get(this, "*", "gpio_axi4l_env_config", env_cfg))
			`uvm_fatal("Virtual Sequence TEST", "Environment configuration not found");
			
		env_cfg.has_axi4l_agent = 1;
		env_cfg.axi4l_agent_config_h.active = UVM_ACTIVE;
		env_cfg.has_gpio_agent = 1;
		env_cfg.gpio_agent_config_h.active = UVM_ACTIVE;
		
		// Set the Environment config back to data base
		uvm_config_db #(gpio_axi4l_env_config)::set(this,"*","gpio_axi4l_env_config",env_cfg);
		
	endfunction
	
	// Run task
	task run_phase(uvm_phase phase);
		
		// Create the Sequence
		vseq_1 = basic_test_vseq::type_id::create("vseq_1");
		vseq_2 = reg_test_vseq::type_id::create("vseq_2");
		
		vseq_1.env_cfg = env_cfg;
		vseq_2.env_cfg = env_cfg;
		
		// Raise the objection
		phase.raise_objection(this);
		
		// Initialize the Sequencer with Virtual Sequencers
		init_vseq(vseq_1);
		init_vseq(vseq_2);
		
		// Start the Sequence
		vseq_1.start(null);
		vseq_2.start(null);
		
		// Drop the objection
		phase.drop_objection(this);
	endtask

endclass
