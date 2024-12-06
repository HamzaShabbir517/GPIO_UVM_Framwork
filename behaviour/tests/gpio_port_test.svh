// Include Macros
`include "uvm_macros.svh"

// Declare GPIO Port Test
class gpio_port_test extends gpio_base_test;
	
	// Register it with factory
	`uvm_component_utils(gpio_port_test)
	
	// New Constructor
	function new(string name = "gpio_port_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Declaration of Sequence
	gpio_sequence gpio_seq;
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	// Run task
	task run_phase(uvm_phase phase);
		
		// Create the Sequence
		gpio_seq = gpio_sequence::type_id::create("gpio_seq");
		
		// Raise the objection
		phase.raise_objection(this);
		
		// Start the Sequence
		gpio_seq.start(gpio_env_h.gpio_agent_h.gpio_sqr_h);
		
		// Drop the objection
		phase.drop_objection(this);
	endtask
endclass
