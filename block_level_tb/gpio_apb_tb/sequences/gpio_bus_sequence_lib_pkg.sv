// Include Defines
`include "apb_defines.svh"

// Declaration of Package
package gpio_bus_sequence_lib_pkg;
	
	// Import UVM Package
	import uvm_pkg::*;
	
	// Include UVM Macro
	`include "uvm_macros.svh"
	
	// Import Register Package
	import gpio_apb_reg_pkg::*;
	
	// Import GPIO Environment Package
	import gpio_apb_env_pkg::*;
	
// Declaration of Base Class
// Declare GPIO Bus Base Sequence
class gpio_bus_base_sequence extends uvm_sequence #(uvm_sequence_item);
	
	// Register it with factory
	`uvm_object_utils(gpio_bus_base_sequence)
	
	// Declaration of Environment Configuration object
	gpio_apb_env_config env_cfg;
	
	// Declare the Register Block
	gpio_apb_reg_block gpio_ral_model;
	
	// Properties used by the various register access methods
	// For passing data
	rand uvm_reg_data_t data; 
	// Returning access status
	uvm_status_e status;
	
	// New Constructor
	function new(string name = "gpio_bus_base_sequence");
		super.new(name);
	endfunction
	
	// Common Body task
	task body();
		// Check if Environment Config is null or what
		if (env_cfg == null)
		 	`uvm_fatal("CONFIG_LOAD", "gpio_env_config is null. Have you set() it?")
		
		// Get the RAL handle from config and pass it to base class
		gpio_ral_model = env_cfg.gpio_rm;
	endtask
endclass

// Declaration of Bus Write Sequence
// Declare GPIO Bus Write Sequence
class gpio_bus_write_sequence extends gpio_bus_base_sequence;
	
	// Register it with factory
	`uvm_object_utils(gpio_bus_write_sequence)
	
	// Declaring an array of register
	uvm_reg gpio_regs[$];
	
	// Decalre of varibale
	int i = 0;
	
	// New Constructor
	function new(string name = "gpio_bus_write_sequence");
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

// Declaraton of Bus Read Sequence
// Declare GPIO Bus Read Sequence
class gpio_bus_read_sequence extends gpio_bus_base_sequence;
	
	// Register it with factory
	`uvm_object_utils(gpio_bus_read_sequence)
	
	// Declaring an array of register
	uvm_reg gpio_regs[$];
	
	uvm_reg_data_t ref_data;
	
	// Decalre of varibale
	int i = 0;
	
	// New Constructor
	function new(string name = "gpio_bus_read_sequence");
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
				`uvm_error("GPIO Bus Read Seq:", $sformatf("get/read: Read error for %s: Expected: %0h Actual: %0h", gpio_regs[i].get_name(), ref_data, data))
			end
		end
	endtask
endclass

// Declare Update Sequence
class gpio_bus_update_sequence extends gpio_bus_base_sequence;
	
	// Register it with factory
	`uvm_object_utils(gpio_bus_update_sequence)
	
	// Declaring an array of register
	uvm_reg gpio_regs[$];
	
	// Decalre of varibale
	int i = 0;
	
	// New Constructor
	function new(string name = "gpio_bus_update_sequence");
		super.new(name);
	endfunction
	
	// Body Task
	task body();
		super.body();
		
		// Randomize the register model to get a new config
		if(!gpio_ral_model.randomize()) begin
			`uvm_error("GPIO Bus Update SEQ:", "gpio ral model randomization failure")
		end
		
		// This will write the generated values to the HW registers
		gpio_ral_model.update(status, .path(UVM_FRONTDOOR), .parent(this));
		
	endtask
endclass

endpackage
