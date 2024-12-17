// Include Macros
`include "uvm_macros.svh"

// Declare GPIO Reg Test
class gpio_reg_test extends gpio_base_test;
	
	// Register it with factory
	`uvm_component_utils(gpio_reg_test)
	
	// Declaration of config objects
	gpio_axi4l_env_config env_cfg;
	
	// Declaring Sequence
	gpio_bus_mix_sequence mix_seq;
	gpio_bus_write_sequence write_seq;
	gpio_bus_read_sequence read_seq;
	
	// New Constructor
	function new(string name = "gpio_reg_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the environment config from database
		if (!uvm_config_db#(gpio_axi4l_env_config)::get(this, "*", "gpio_axi4l_env_config", env_cfg))
			`uvm_fatal("RAL TEST", "Environment configuration not found");
			
		env_cfg.has_axi4l_agent = 1;
		env_cfg.axi4l_agent_config_h.active = UVM_ACTIVE;
		
		// Set the Environment config back to data base
		uvm_config_db #(gpio_axi4l_env_config)::set(this,"*","gpio_axi4l_env_config",env_cfg);
	
	endfunction
	
	// Run task
	task run_phase(uvm_phase phase);
		
		// Create the Sequence
		mix_seq = gpio_bus_mix_sequence::type_id::create("mix_seq");
		write_seq = gpio_bus_write_sequence::type_id::create("write_seq");
		read_seq = gpio_bus_read_sequence::type_id::create("read_seq");
		
		// Raise the objection
		phase.raise_objection(this);
		
		
		fork
			// Start the Sequence
			write_seq.start(gpio_axi4l_env_h.axi4l_agent_h.axi4l_sqr_h);
			read_seq.start(gpio_axi4l_env_h.axi4l_agent_h.axi4l_sqr_h);
		
		join
		
		// Start the Sequence
		mix_seq.start(gpio_axi4l_env_h.axi4l_agent_h.axi4l_sqr_h);
		
		// Drop the objection
		phase.drop_objection(this);
	endtask
endclass
