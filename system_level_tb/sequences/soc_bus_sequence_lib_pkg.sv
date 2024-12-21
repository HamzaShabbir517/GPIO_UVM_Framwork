// Declaration of Package
package soc_bus_sequence_lib_pkg;

	// Import UVM Package
	import uvm_pkg::*;
	
	// Include UVM Macro
	`include "uvm_macros.svh"
	
	// Import SoC Environment Package
	import soc_env_pkg::*;
	
	// Import Reg Package
	import soc_reg_pkg::*;
	
	// Import Register Package
	import gpio_apb_reg_pkg::*;
	
// Declaration of SoC Bus Base Sequence
class soc_bus_base_sequence extends uvm_sequence #(uvm_sequence_item);
	
	// Register it with factory
	`uvm_object_utils(soc_bus_base_sequence)
	
	// Declaration of Config Object
	soc_env_config env_cfg;
	
	// Declaration of Register models
	gpio_axi4l_reg_block gpio_axi4l_ral_model;
	gpio_apb_reg_block   gpio_apb_ral_model;
	
	// Properties used by the various register access methods
	// For passing data
	rand uvm_reg_data_t data; 
	// Returning access status
	uvm_status_e status;
	
	// New Constructor
	function new(string name = "soc_bus_base_sequence");
		super.new(name);
	endfunction
	
	// Common Body task
	task body();
		// Check if Environment Config is null or what
		if (env_cfg == null)
		 	`uvm_fatal("CONFIG_LOAD", "soc_env_config is null. Have you set() it?")
		
		// Get the RAL handle from config and pass it to base class
		gpio_axi4l_ral_model = env_cfg.soc_rm.gpio_axi4l_rb;
		gpio_apb_ral_model = env_cfg.soc_rm.gpio_apb_rb;
	endtask
endclass

// Declaration of Write Sequence
class soc_bus_write_sequence extends soc_bus_base_sequence;
	
	// Register it with factory
	`uvm_object_utils(soc_bus_write_sequence)
	
	// Declaring an array of register
	uvm_reg gpio_axi4l_regs[$];
	uvm_reg gpio_apb_regs[$];
	
	// Decalre of varibale
	int i = 0, j=0;
	
	// New Constructor
	function new(string name = "soc_bus_write_sequence");
		super.new(name);
	endfunction
	
	// Body Task
	task body();
		super.body();
		
		// Get the Registers
		gpio_axi4l_ral_model.get_registers(gpio_axi4l_regs);
		gpio_apb_ral_model.get_registers(gpio_apb_regs);
		
		// Shuffle the register
		gpio_axi4l_regs.shuffle();
		gpio_apb_regs.shuffle();
		
		fork 
			begin
				foreach(gpio_axi4l_regs[i]) begin
			
					// Randomize the data
					assert(this.randomize());
			
					// Write the data onto registers
					gpio_axi4l_regs[i].write(status, data, .parent(this));
				end
			end
			begin
				foreach(gpio_apb_regs[j]) begin
					// Randomize the data
					assert(this.randomize());
			
					// Write the data onto registers
					gpio_apb_regs[j].write(status, data, .parent(this));
				end
			end
		join
	endtask
	
endclass
endpackage
