// Declaration of GPIO Agent Configuration Object
class gpio_agent_config extends uvm_object;
	
	// Register it with factory
	`uvm_object_utils(gpio_agent_config)
	
	// Declaration of Variable
	uvm_active_passive_enum active = UVM_ACTIVE;
	
	// Number of GPIO Pins
	int num_pins = 8;
	
	// Declaration of interface
	virtual gpio_interface #(num_pins) gpio_if;
	
	// New Cosntructor
	function new (string name = "gpio_agent_config");
		super.new(name);
	endfunction
endclass
