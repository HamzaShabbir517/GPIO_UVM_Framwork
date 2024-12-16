// Include defines
`include "axi4l_defines.svh"

// Declare AXI4 Lite Sequence
class axi4l_sequence extends uvm_sequence #(axi4l_sequence_item #(`data_width,`addr_width));
	
	// Register it with factory
	`uvm_object_utils(axi4l_sequence)
	
	// Declaraton of Sequence item
	axi4l_sequence_item #(`data_width,`addr_width) seq_item;
	
	// New Constructor
	function new(string name = "axi4l_sequence");
		super.new(name);
	endfunction 
	
	// Body task (it is equivalent to run task of uvm_component)
	task body();
		
		// Create the Sequence Item
		seq_item = axi4l_sequence_item #(`data_width,`addr_width)::type_id::create("seq_item");
		
		// Repeating the Sequence for multiple times
		repeat(50) begin
			
			// Start the Sequence Item handshaking 
			start_item(seq_item);
		
			// Randomize the Sequence item
			assert(seq_item.randomize());
		
			// Finish the Sequence Item handshaking 
			finish_item(seq_item);
			
			// Print the values
			`uvm_info("AXI4 Lite Sequence",seq_item.convert2string(),UVM_MEDIUM);
		end
	endtask
endclass
