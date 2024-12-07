// Declare RAL Write Sequence
class ral_write_sequence extends ral_base_sequence;
	
	// Register it with factory
	`uvm_object_utils(ral_write_sequence)
	
	// Declaring an array of register
	uvm_reg gpio_regs[$];
	
	// Decalre of varibale
	int i = 0;
	
	// New Constructor
	function new(string name = "ral_write_sequence");
		super.new(name);
	endfunction
	
	// Body Task
	task body();
		super.body();
		
		// Get all the registers
		gpio_ral_model.get_registers(gpio_regs);
		
		// Shuffle the register
		gpio_regs.shuffle();
		
		// Iterate to each register and write values
		foreach(gpio_regs[i]) begin
			
			// Randomize the data
			assert(this.randomize());
			
			// Write the data onto registers
			gpio_regs[i].write(status, data, .parent(this));
		end
	endtask
endclass
