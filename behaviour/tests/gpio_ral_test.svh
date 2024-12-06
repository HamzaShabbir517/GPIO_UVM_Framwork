// Include Macros
`include "uvm_macros.svh"

// Declare GPIO RAL Test
class gpio_ral_test extends gpio_base_test;
	
	// Register it with factory
	`uvm_component_utils(gpio_ral_test)
	
	// New Constructor
	function new(string name = "gpio_ral_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Declaration of GPIO RAL Model
	gpio_reg_block m_ral;
	
	// Declaration of config objects
	gpio_env_config env_cfg;
	
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
		
		// Set the Environment config back to data base
		uvm_config_db #(gpio_env_config)::set(this,"*","gpio_env_config",env_cfg);
	
	endfunction
endclass
