// Include defines
`include "gpio_defines.svh"

// Declare GPIO sequencer class
class gpio_sequencer #(int NUM_PINS = 8) extends uvm_sequencer #(gpio_sequence_item #(`NUM_PINS));

	// Register it with factory
	`uvm_component_param_utils(gpio_sequencer #(`NUM_PINS))
	
	// New Constructor
	function new(string name = "gpio_sequencer", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
endclass
