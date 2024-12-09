// Include Macros
`include "uvm_macros.svh"

// Declare GPIO RAL Test
class gpio_ral_test extends gpio_base_test;
	
	// Register it with factory
	`uvm_component_utils(gpio_ral_test)
	
	// Declaration of GPIO RAL Model
	gpio_reg_block m_ral;
	
	// Declaration of config objects
	gpio_env_config env_cfg;
	
	// Declaring Sequence
	ral_write_sequence write_seq;
	ral_read_sequence read_seq;
	
	// New Constructor
	function new(string name = "gpio_ral_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Create Register map
		m_ral = gpio_reg_block::type_id::create("m_ral", this);
		m_ral.build();
		
		// Get the environment config from database
		if (!uvm_config_db#(gpio_env_config)::get(this, "*", "gpio_env_config", env_cfg))
			`uvm_fatal("RAL TEST", "Environment configuration not found");
			
		env_cfg.gpio_rm = m_ral;
		env_cfg.has_axi4l_agent = 1;
		
		// Set the Environment config back to data base
		uvm_config_db #(gpio_env_config)::set(this,"*","gpio_env_config",env_cfg);
	
	endfunction
	
	// Run task
	task run_phase(uvm_phase phase);
		
		// Create the Sequence
		write_seq = ral_write_sequence::type_id::create("write_seq");
		read_seq = ral_read_sequence::type_id::create("read_seq");
		
		// Raise the objection
		phase.raise_objection(this);
		
		// Assign the register model to the sequence
		write_seq.gpio_ral_model = m_ral;
		read_seq.gpio_ral_model = m_ral;
		
		fork
			// Start the Sequence
			write_seq.start(gpio_env_h.axi4l_agent_h.axi4l_sqr_h);
			read_seq.start(gpio_env_h.axi4l_agent_h.axi4l_sqr_h);
		
		join
		
		// Drop the objection
		phase.drop_objection(this);
	endtask
endclass
