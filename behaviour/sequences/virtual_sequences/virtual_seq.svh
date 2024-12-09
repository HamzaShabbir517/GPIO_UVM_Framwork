// Include defines
`include "axi4l_defines.svh"
`include "gpio_defines.svh"

// Declaration of Virtual Sequence Class
class virtual_seq extends vseq_base;
	
	// Register it with factory
	`uvm_object_utils(virtual_seq)
	
	// Declaration of Sequences
	gpio_sequence gpio_seq;
	axi4l_sequence axi4l_seq;
	
	// New Constructor
	function new(string name = "virtual_seq");
		super.new(name);
	endfunction
	
	// Body task (it is equivalent to run task of uvm_component)
	task body();
		
		// Create the Sequences
		gpio_seq = gpio_sequence::type_id::create("gpio_seq");
		axi4l_seq = axi4l_sequence::type_id::create("axi4l_seq");
		
		// Start the sequences on to their respective sequencers parallely
		fork
			gpio_seq.start(gpio_sqr_h);
			axi4l_seq.start(axi4l_sqr_h);
		join
			
	endtask 
endclass 
