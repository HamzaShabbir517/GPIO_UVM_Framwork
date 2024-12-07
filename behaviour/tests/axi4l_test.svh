// Include Macros
`include "uvm_macros.svh"

// Declare AXI4 Lite Test
class axi4l_test extends gpio_base_test;
	
	// Register it with factory
	`uvm_component_utils(axi4l_test)
	
	// New Constructor
	function new(string name = "axi4l_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Declaration of Sequence
	axi4l_sequence axi4l_seq;
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	// Run task
	task run_phase(uvm_phase phase);
		
		// Create the Sequence
		axi4l_seq = axi4l_sequence::type_id::create("axi4l_seq");
		
		// Raise the objection
		phase.raise_objection(this);
		
		// Start the Sequence
		axi4l_seq.start(gpio_env_h.axi4l_agent_h.axi4l_sqr_h);
		
		// Drop the objection
		phase.drop_objection(this);
	endtask
endclass
