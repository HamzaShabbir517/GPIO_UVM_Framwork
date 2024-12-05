// Declaration of GPIO Registers

// Declaration of GPIO Direction Register
class gpio_dir extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_dir)
	
	// Declaring individual fields
	rand uvm_reg_field dir;
	
	// New Constructor
	function new(string name = "gpio_dir");
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

// Declaration of GPIO Ouptut Set Register
class gpio_output_set extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_output_set)
	
	// Declaring individual fields
	rand uvm_reg_field data_set;
	
	// New Constructor
	function new(string name = "gpio_output_set");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		data_set = uvm_reg_field::type_id::create("data_set");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand,fieldAccess)
		data_set.configure(this,32,0,"WO",0,32'h00000000,1,1,1);
	endfunction
endclass

// Declaration of GPIO Ouptut Clear Register
class gpio_output_clear extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_output_clear)
	
	// Declaring individual fields
	rand uvm_reg_field data_clear;
	
	// New Constructor
	function new(string name = "gpio_output_clear");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		data_clear = uvm_reg_field::type_id::create("data_clear");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand,fieldAccess)
		data_clear.configure(this,32,0,"WO",0,32'h00000000,1,1,1);
	endfunction
endclass

// Declaration of GPIO Interrupt Mask Register
class gpio_interrupt_mask extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_interrupt_mask)
	
	// Declaring individual fields
	rand uvm_reg_field mask;
	
	// New Constructor
	function new(string name = "gpio_interrupt_mask");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		mask = uvm_reg_field::type_id::create("mask");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand,fieldAccess)
		mask.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
	endfunction
endclass

// Declaration of GPIO Interrupt Set Register
class gpio_interrupt_set extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_interrupt_set)
	
	// Declaring individual fields
	rand uvm_reg_field int_set;
	
	// New Constructor
	function new(string name = "gpio_interrupt_set");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		int_set = uvm_reg_field::type_id::create("int_set");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand,fieldAccess)
		int_set.configure(this,32,0,"WO",0,32'h00000000,1,1,1);
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

// Declaration of GPIO Interrupt Level Register
class gpio_interrupt_level extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_interrupt_level)
	
	// Declaring individual fields
	rand uvm_reg_field int_level;
	
	// New Constructor
	function new(string name = "gpio_interrupt_level");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		int_level = uvm_reg_field::type_id::create("int_level");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand,fieldAccess)
		int_level.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
	endfunction
endclass

// Declaration of GPIO Interrupt Mode Register
class gpio_interrupt_mode extends uvm_reg;

	// Register it with factory
	`uvm_object_utils(gpio_interrupt_mode)
	
	// Declaring individual fields
	rand uvm_reg_field int_mode;
	
	// New Constructor
	function new(string name = "gpio_interrupt_mode");
		super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
	endfunction
	
	// Build Function
	virtual function void build();
		// Create the reg field
		int_mode = uvm_reg_field::type_id::create("int_mode");
		// Configure the register
		// (this, size, lsb, access, volatility, reset, hasReset, isRand,fieldAccess)
		int_mode.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
	endfunction
endclass
