// Include defines
`include "gpio_defines.svh"

// Declare GPIO Sequence
class gpio_sequence extends uvm_sequence #(gpio_sequence_item #(`NUM_PINS));
	
	// Register it with factory
	`uvm_object_utils(gpio_sequence)
	
	// Declaraton of Sequence item
	gpio_sequence_item #(`NUM_PINS) seq_item;
	
	// New Constructor
	function new(string name = "gpio_sequence");
		super.new(name);
	endfunction 
	
	// Body task (it is equivalent to run task of uvm_component)
	task body();
		
		// Create the Sequence Item
		seq_item = gpio_sequence_item #(`NUM_PINS)::type_id::create("seq_item");
		
		// Repeating the Sequence for multiple times
		repeat(10) begin
			
			// Start the Sequence Item handshaking 
			start_item(seq_item);
		
			// Randomize the Sequence item
			assert(seq_item.randomize());
		
			// Finish the Sequence Item handshaking 
			finish_item(seq_item);
			
			// Print the values
			`uvm_info("GPIO Sequence",seq_item.convert2string(),UVM_MEDIUM);
		end
	endtask
endclass
