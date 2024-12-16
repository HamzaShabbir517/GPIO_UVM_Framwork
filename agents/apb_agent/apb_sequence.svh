// Include defines
`include "apb_defines.svh"

// Declare APB Sequence
class apb_sequence extends uvm_sequence #(apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE));

	// Register it with factory
	`uvm_object_utils(apb_sequence)
	
	// Declaraton of Sequence item
	apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE) seq_item;
	
	// New Constructor
	function new(string name = "apb_sequence");
		super.new(name);
	endfunction
	
	// Body task (it is equivalent to run task of uvm_component)
	task body();
		
		// Create the Sequence Item
		seq_item = apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE)::type_id::create("seq_item");
		
		// Repeating the Sequence for multiple times
		repeat(50) begin
			
			// Start the Sequence Item handshaking 
			start_item(seq_item);
		
			// Randomize the Sequence item
			assert(seq_item.randomize());
		
			// Finish the Sequence Item handshaking 
			finish_item(seq_item);
			
			// Print the values
			`uvm_info("APB Sequence",seq_item.convert2string(),UVM_MEDIUM);
		end
	endtask
endclass
