// Declaration of Package
package gpio_axi4l_reg_pkg;
	
	// Import UVM Package
	import uvm_pkg::*;
	
	// Include UVM macros
	`include "uvm_macros.svh"
	
	// Declaration of GPIO Registers

// Declaration of GPIO Ouptut Register
class gpio_output extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_output)
	
	// Declaring individual fields
	rand uvm_reg_field data;
	
	// New Constructor
	function new(string name = "gpio_output");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		data = uvm_reg_field::type_id::create("data");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
		data.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
	endfunction
endclass

// Declaration of GPIO Output Enable Register
class gpio_output_en extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_output_en)
	
	// Declaring individual fields
	rand uvm_reg_field dir;
	
	// New Constructor
	function new(string name = "gpio_output_en");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		dir = uvm_reg_field::type_id::create("dir");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
		dir.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
	endfunction
endclass

// Declaration of GPIO Input Register
class gpio_input extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_input)
	
	// Declaring individual fields
	rand uvm_reg_field value;
	
	// New Constructor
	function new(string name = "gpio_input");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		value = uvm_reg_field::type_id::create("value");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
		value.configure(this,32,0,"RO",0,32'h00000000,1,1,1);
	endfunction
endclass

// Declaration of GPIO Interrupt Enable Register
class gpio_interrupt_en extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_interrupt_en)
	
	// Declaring individual fields
	rand uvm_reg_field enable;
	
	// New Constructor
	function new(string name = "gpio_interrupt_en");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		enable = uvm_reg_field::type_id::create("enable");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand,fieldAccess)
		enable.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
	endfunction
endclass

// Declaration of GPIO Interrupt status Register
class gpio_interrupt_status extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_interrupt_status)
	
	// Declaring individual fields
	rand uvm_reg_field int_status;
	
	// New Constructor
	function new(string name = "gpio_interrupt_status");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		int_status = uvm_reg_field::type_id::create("int_status");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand,fieldAccess)
		int_status.configure(this,32,0,"RO",0,32'h00000000,1,1,1);
	endfunction
endclass

// Declaration of GPIO Interrupt Clear Register
class gpio_interrupt_clear extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_interrupt_clear)
	
	// Declaring individual fields
	rand uvm_reg_field int_clear;
	
	// New Constructor
	function new(string name = "gpio_interrupt_clear");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		int_clear = uvm_reg_field::type_id::create("int_clear");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand,fieldAccess)
		int_clear.configure(this,32,0,"WO",0,32'h00000000,1,1,1);
	endfunction
endclass

// Declaration of GPIO Register Block
class gpio_axi4l_reg_block extends uvm_reg_block;
	
	// Register it with factory
	`uvm_object_utils(gpio_axi4l_reg_block)
	
	// Declaration of Registers
	rand gpio_output     	   gpio_output_reg;
	rand gpio_output_en        gpio_output_en_reg;
	rand gpio_input      	   gpio_input_reg;
	rand gpio_interrupt_en	   gpio_interrupt_en_reg;
	rand gpio_interrupt_status gpio_interrupt_status_reg;
	rand gpio_interrupt_clear  gpio_interrupt_clear_reg;
	
	// Declaration of Map
	uvm_reg_map gpio_axi4l_map;
	
	// New Constructor
	function new(string name = "gpio_axi4l_reg_block");
		super.new(name, UVM_NO_COVERAGE);
	endfunction

	// Build Function
	virtual function void build();
		// Create the Register, Configure it and than build
		// Backdoor Access  add_hdl_path_slice(Register name, starting bit, size);
		
		// Output Register
		gpio_output_reg = gpio_output::type_id::create("gpio_output_reg");
		gpio_output_reg.configure(this, null, "");
		gpio_output_reg.build();
		
		// gpio_output_reg.add_hdl_path_slice("gpio_out", 0, 32);
		
		// Output Enable Register
		gpio_output_en_reg = gpio_output_en::type_id::create("gpio_output_en_reg");
		gpio_output_en_reg.configure(this, null, "");
		gpio_output_en_reg.build();
		
		// Input Register
		gpio_input_reg = gpio_input::type_id::create("gpio_input_reg");
		gpio_input_reg.configure(this, null, "");
		gpio_input_reg.add_hdl_path_slice("gpio_in_reg", 0, 32);
		gpio_input_reg.build();
		
		// Interrupt Mask Register
		gpio_interrupt_en_reg = gpio_interrupt_en::type_id::create("gpio_interrupt_en_reg");
		gpio_interrupt_en_reg.configure(this, null, "");
		gpio_interrupt_en_reg.add_hdl_path_slice("gpio_int_enable", 0, 32);
		gpio_interrupt_en_reg.build();
		
		// Interrupt Status Register
		gpio_interrupt_status_reg = gpio_interrupt_status::type_id::create("gpio_interrupt_status_reg");
		gpio_interrupt_status_reg.configure(this, null, "");
		gpio_interrupt_status_reg.add_hdl_path_slice("gpio_int_status", 0, 32);
		gpio_interrupt_status_reg.build();
		
		// Interrupt Clear Register
		gpio_interrupt_clear_reg = gpio_interrupt_clear::type_id::create("gpio_interrupt_clear_reg");
		gpio_interrupt_clear_reg.configure(this, null, "");
		gpio_interrupt_clear_reg.build();
		
		// Create the address Map
		// (name, base address, byte address, Endian);
		gpio_axi4l_map = create_map("gpio_axi4l_map", 'h0, 4, UVM_LITTLE_ENDIAN);
		gpio_axi4l_map.add_reg(gpio_output_reg, 'h00, "RW");
		gpio_axi4l_map.add_reg(gpio_output_en_reg, 'h04, "RW");
		gpio_axi4l_map.add_reg(gpio_input_reg, 'h08, "RO");
		gpio_axi4l_map.add_reg(gpio_interrupt_en_reg, 'h0C, "RW");
		gpio_axi4l_map.add_reg(gpio_interrupt_status_reg, 'h10, "RO");
		gpio_axi4l_map.add_reg(gpio_interrupt_clear_reg, 'h14, "WO");
		
		add_hdl_path("hdl_top.axi_dut", "RTL");
		lock_model();
		
	endfunction
endclass
	
endpackage
