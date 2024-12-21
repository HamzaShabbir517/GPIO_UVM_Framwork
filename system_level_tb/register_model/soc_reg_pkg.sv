// Declaration of SoC Package
package soc_reg_pkg;

	// Import UVM Package
	import uvm_pkg::*;
	
	// Include UVM macros
	`include "uvm_macros.svh"
	
	// Import GPIO APB Register Package
	import gpio_apb_reg_pkg::*;
	
	// Inlcude GPIO AXI4 Lite Register Files
	import gpio_axi4l_reg_pkg::*;
	
	// Declaration of SoC Reg Block
	class soc_reg_block extends uvm_reg_block;
		
		// Register it with factory
		`uvm_object_utils(soc_reg_block)
		
		// Declaration of Registers block
		gpio_axi4l_reg_block gpio_axi4l_rb;
		gpio_apb_reg_block   gpio_apb_rb;
		
		// Declaration of Map
		uvm_reg_map soc_map;
		
		// New Constructor
		function new(string name = "soc_reg_block");
			super.new(name,build_coverage(UVM_CVR_ALL));
		endfunction
		
		// Build function
		virtual function void build();
			
			// Create the register model
			gpio_axi4l_rb = gpio_axi4l_reg_block::type_id::create("gpio_axi4l_rb");
			gpio_axi4l_rb.configure(this);
			gpio_axi4l_rb.build();
			
			gpio_apb_rb = gpio_apb_reg_block::type_id::create("gpio_apb_rb");
			gpio_apb_rb.configure(this);
			gpio_apb_rb.build();
			
			// Create the map
			soc_map =  create_map("soc_map", 'h0, 4, UVM_LITTLE_ENDIAN, 1);
			default_map = soc_map;
			
			// Add the sub map
			soc_map.add_submap(gpio_axi4l_rb.gpio_axi4l_map, 'h0);
			soc_map.add_submap(gpio_apb_rb.gpio_apb_map, 'h1000);
			
			lock_model();
		endfunction
	endclass
endpackage
