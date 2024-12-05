// Include Defines
`include "gpio_defines.svh"

// Declaration of GPIO Agent Configuration Object
class gpio_agent_config extends uvm_object;
	
	// Register it with factory
	`uvm_object_utils(gpio_agent_config)
	
	// Declaration of Variable
	uvm_active_passive_enum active = UVM_ACTIVE;
	
	// Declaration of interface
	virtual gpio_interface #(`NUM_PINS) gpio_if;
	
	// New Cosntructor
	function new (string name = "gpio_agent_config");
		super.new(name);
	endfunction
endclass
