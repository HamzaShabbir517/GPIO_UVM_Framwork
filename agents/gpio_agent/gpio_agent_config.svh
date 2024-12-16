// Include Defines
`include "gpio_defines.svh"

// Declaration of GPIO Agent Configuration Object
class gpio_agent_config extends uvm_object;

	// Declaring some local parameters
	localparam string s_my_config_id = "gpio_agent_config";
	localparam string s_no_config_id = "no config";
	localparam string s_my_config_type_error_id = "config type error";
	
	// Register it with factory
	`uvm_object_utils(gpio_agent_config)
	
	// Declaration of interface
	virtual gpio_interface #(`NUM_PINS) gpio_if;
	
	// Declaration of Variable
	// Is agent active or passive
	uvm_active_passive_enum active = UVM_ACTIVE;
	bit has_functional_coverage = 0;
	
	// New Cosntructor
	function new (string name = "gpio_agent_config");
		super.new(name);
	endfunction
	
	// Get config fucntion
	function gpio_agent_config get_config(uvm_component c);
		gpio_agent_config t;
			
		// Get config from data base
		if (!uvm_config_db #(gpio_agent_config)::get(c,"*",s_my_config_id, t))
			`uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))
			
		return t;
	endfunction
endclass
