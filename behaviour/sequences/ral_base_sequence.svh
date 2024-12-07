// Include defines
`include "axi4l_defines.svh"

// Declare RAL Base Sequence
class ral_base_sequence extends uvm_sequence #(axi4l_sequence_item #(`data_width,`addr_width));

	// Register it with factory
	`uvm_object_utils(ral_base_sequence)
	
	// Declaration of Environment Configuration object
	gpio_env_config env_cfg_h;
	
	// Declare the Register Block
	gpio_reg_block gpio_ral_model;
	
	// Properties used by the various register access methods
	// For passing data
	rand uvm_reg_data_t data; 
	// Returning access status
	uvm_status_e status;
	
	// New Constructor
	function new(string name = "ral_base_sequence");
		super.new(name);
	endfunction
	
	// Common Body task
	task body();
		
		// Get the config object from data base
		if(!uvm_config_db #(gpio_env_config)::get(m_sequencer,"*","gpio_env_config",env_cfg_h))
		`uvm_error("RAL Base Sequence", "unable to get gpio_env_config");
		
		// Get the RAL handle from config and pass it to base class
		gpio_ral_model = env_cfg_h.gpio_rm;
	endtask
endclass
