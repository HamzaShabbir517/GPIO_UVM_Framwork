// Declaration of GPIO Register Block
class gpio_reg_block extends uvm_reg_block;
	
	// Register it with factory
	`uvm_object_utils(gpio_reg_block)
	
	// Declaration of Registers
	rand gpio_dir        	   gpio_dir_reg;
	rand gpio_input      	   gpio_input_reg;
	rand gpio_output     	   gpio_output_reg;
	rand gpio_output_set 	   gpio_output_set_reg;
	rand gpio_output_clear     gpio_output_clear_reg;
	rand gpio_interrupt_mask   gpio_interrupt_mask_reg;
	rand gpio_interrupt_set    gpio_interrupt_set_reg;
	rand gpio_interrupt_clear  gpio_interrupt_clear_reg;
	rand gpio_interrupt_status gpio_interrupt_status_reg;
	rand gpio_interrupt_level  gpio_interrupt_level_reg;
	rand gpio_interrupt_mode   gpio_interrupt_mode_reg;
	
	// Declaration of Map
	uvm_reg_map axi4l_map;
	
	// New Constructor
	function new(string name = "gpio_reg_block");
		super.new(name, UVM_NO_COVERAGE);
	endfunction

	// Build Function
	virtual function void build();
		// Create the Register, Configure it and than build
		// Direction Register
		gpio_dir_reg = gpio_dir::type_id::create("gpio_dir_reg");
		gpio_dir_reg.configure(this, null, "");
		gpio_dir_reg.build();
		
		// Input Register
		gpio_input_reg = gpio_input::type_id::create("gpio_input_reg");
		gpio_input_reg.configure(this, null, "");
		gpio_input_reg.build();
		
		// Output Register
		gpio_output_reg = gpio_output::type_id::create("gpio_output_reg");
		gpio_output_reg.configure(this, null, "");
		gpio_output_reg.build();
		
		// Output Set Register
		gpio_output_set_reg = gpio_output_set::type_id::create("gpio_output_set_reg");
		gpio_output_set_reg.configure(this, null, "");
		gpio_output_set_reg.build();
		
		// Output Clear Register
		gpio_output_clear_reg = gpio_output_clear::type_id::create("gpio_output_clear_reg");
		gpio_output_clear_reg.configure(this, null, "");
		gpio_output_clear_reg.build();
		
		// Interrupt Mask Register
		gpio_interrupt_mask_reg = gpio_interrupt_mask::type_id::create("gpio_interrupt_mask_reg");
		gpio_interrupt_mask_reg.configure(this, null, "");
		gpio_interrupt_mask_reg.build();
		
		// Interrupt Set Register
		gpio_interrupt_set_reg = gpio_interrupt_set::type_id::create("gpio_interrupt_set_reg");
		gpio_interrupt_set_reg.configure(this, null, "");
		gpio_interrupt_set_reg.build();
		
		// Interrupt Clear Register
		gpio_interrupt_clear_reg = gpio_interrupt_clear::type_id::create("gpio_interrupt_clear_reg");
		gpio_interrupt_clear_reg.configure(this, null, "");
		gpio_interrupt_clear_reg.build();
		
		// Interrupt Status Register
		gpio_interrupt_status_reg = gpio_interrupt_status::type_id::create("gpio_interrupt_status_reg");
		gpio_interrupt_status_reg.configure(this, null, "");
		gpio_interrupt_status_reg.build();
		
		// Interrupt Level Register
		gpio_interrupt_level_reg = gpio_interrupt_level::type_id::create("gpio_interrupt_level_reg");
		gpio_interrupt_level_reg.configure(this, null, "");
		gpio_interrupt_level_reg.build();
		
		// Interrupt Mode Register
		gpio_interrupt_mode_reg = gpio_interrupt_mode::type_id::create("gpio_interrupt_mode_reg");
		gpio_interrupt_mode_reg.configure(this, null, "");
		gpio_interrupt_mode_reg.build();
		
		// Create the address Map
		// (name, base address, byte address, Endian);
		axi4l_map = create_map("axi4l_map", 'h0, 4, UVM_LITTLE_ENDIAN);
		axi4l_map.add_reg(gpio_dir_reg, 8'h00, "RW");
		axi4l_map.add_reg(gpio_input_reg, 8'h04, "RW");
		axi4l_map.add_reg(gpio_output_reg, 8'h08, "RW");
		axi4l_map.add_reg(gpio_output_set_reg, 8'h0C, "WO");
		axi4l_map.add_reg(gpio_output_clear_reg, 8'h10, "WO");
		axi4l_map.add_reg(gpio_interrupt_mask_reg, 8'h14, "RW");
		axi4l_map.add_reg(gpio_interrupt_set_reg, 8'h18, "WO");
		axi4l_map.add_reg(gpio_interrupt_clear_reg, 8'h1C, "WO");
		axi4l_map.add_reg(gpio_interrupt_status_reg, 8'h20, "RO");
		axi4l_map.add_reg(gpio_interrupt_level_reg, 8'h24, "RW");
		axi4l_map.add_reg(gpio_interrupt_mode_reg, 8'h28, "RW");
		lock_model();
		
	endfunction
endclass
