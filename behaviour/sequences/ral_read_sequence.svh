// Declare RAL Read Sequence
class ral_read_sequence extends ral_base_sequence;
	
	// Register it with factory
	`uvm_object_utils(ral_read_sequence)
	
	// Declaring an array of register
	uvm_reg gpio_regs[$];
	
	uvm_reg_data_t ref_data;
	
	// Decalre of varibale
	int i = 0;
	
	// New Constructor
	function new(string name = "ral_read_sequence");
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
			
			// Get the desired value
			ref_data = gpio_regs[i].get();
			
			// Write the data onto registers
			gpio_regs[i].read(status, data, .parent(this));
			
			// Check if both values are equal
			if(ref_data != data) begin
				`uvm_error("RAL Read Seq:", $sformatf("get/read: Read error for %s: Expected: %0h Actual: %0h", gpio_regs[i].get_name(), ref_data, data))
			end
		end
	endtask
endclass
