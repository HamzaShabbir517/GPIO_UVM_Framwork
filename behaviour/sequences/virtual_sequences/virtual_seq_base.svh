// Declaration of includes
`include "axi4l_defines.svh"
`include "gpio_defines.svh"

// Declaration of Virtual Base Sequence Class
class vseq_base extends uvm_sequence #(uvm_sequence_item);

	// Register it with factory
	`uvm_object_utils(vseq_base)
	
	// Initiate the Sequencers
	uvm_sequencer #(axi4l_sequence_item #(`data_width,`addr_width),axi4l_sequence_item #(`data_width,`addr_width)) axi4l_sqr_h;
	
	uvm_sequencer #(gpio_sequence_item #(`NUM_PINS),gpio_sequence_item #(`NUM_PINS)) gpio_sqr_h;
	
	// New Constructor
	function new(string name = "vseq_base");
		super.new(name);
	endfunction 
endclass
