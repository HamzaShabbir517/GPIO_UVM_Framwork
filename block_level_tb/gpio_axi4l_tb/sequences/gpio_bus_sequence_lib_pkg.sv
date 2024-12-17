// Include Defines
`include "axi4l_defines.svh"

// Declaration of Package
package gpio_bus_sequence_lib_pkg;
	
	// Import UVM Package
	import uvm_pkg::*;
	
	// Include UVM Macro
	`include "uvm_macros.svh"
	
	// Import GPIO Environment Package
	import gpio_axi4l_env_pkg::*;
	

// Declaration of Base Class
// Declare GPIO Bus Base Sequence
class gpio_bus_base_sequence extends uvm_sequence #(uvm_sequence_item);

	// Register it with factory
	`uvm_object_utils(gpio_bus_base_sequence)
	
	// Declaration of Environment Configuration object
	gpio_axi4l_env_config env_cfg;
	
	// Declare the Register Block
	gpio_axi4l_reg_block gpio_ral_model;
	
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
		
		// Get the config object from data base
		if(!uvm_config_db #(gpio_axi4l_env_config)::get(m_sequencer,"*","gpio_axi4l_env_config",env_cfg))
			`uvm_error("GPIO Bus Base Sequence", "unable to get gpio_axi4l_env_config");
		
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

// Declaration of GPIO Bus Mix Sequence
// Declare GPIO Bus Mix Sequence
class gpio_bus_mix_sequence extends gpio_bus_base_sequence;
	
	// Register it with factory
	`uvm_object_utils(gpio_bus_mix_sequence)
	
	// Declaration of Reference Data
	uvm_reg_data_t ref_data;
	
	// New Constructor
	function new(string name = "gpio_bus_mix_sequence");
		super.new(name);
	endfunction
	
	// Body Task
	task body();
		super.body();
		
		// First Sequence
		// Set the output enable half as input and half as output
		gpio_ral_model.gpio_output_en_reg.set(32'h0000_FFFF);
		// Update the Register
	gpio_ral_model.gpio_output_en_reg.update(status,.path(UVM_FRONTDOOR),.parent(this));
		// Get the data
		data = gpio_ral_model.gpio_output_en_reg.get();
		
		// Second Sequence
		// Read the reset value and compare it
		ref_data = gpio_ral_model.gpio_interrupt_en_reg.get_reset();
		// Read the actual value
		gpio_ral_model.gpio_interrupt_en_reg.read(status,data,.parent(this));
		// Compare them
		if(ref_data != data) begin
			`uvm_error("GPIO Bus MIX SEQ:", $sformatf("Reset read error for %s: Expected: %0h Actual: %0h", gpio_ral_model.gpio_interrupt_en_reg.get_name(), ref_data, data))
		end
		// Third Sequence
		// Use backdoor access
		gpio_ral_model.gpio_interrupt_en_reg.poke(status, 32'hFFFF_EEEE, .parent(this));
		// Get the Desire value
		ref_data = gpio_ral_model.gpio_interrupt_en_reg.get();
		// Read the actual value
		gpio_ral_model.gpio_interrupt_en_reg.peek(status, data, .parent(this));
		// Compare them
		if(ref_data[31:0] != data[31:0]) begin
			`uvm_error("GPIO Bus MIX SEQ:", $sformatf("poke/peek: Read error for %s: Expected: %0h Actual: %0h", gpio_ral_model.gpio_interrupt_en_reg.get_name(), ref_data, data))
		end
		
		// Fourth Sequence
		// Randomize the register model to get a new config
		if(!gpio_ral_model.randomize()) begin
			`uvm_error("GPIO Bus MIX SEQ:", "gpio ral model randomization failure")
		end
		// This will write the generated values to the HW registers
		gpio_ral_model.update(status, .path(UVM_FRONTDOOR), .parent(this));

	endtask
endclass

endpackage
