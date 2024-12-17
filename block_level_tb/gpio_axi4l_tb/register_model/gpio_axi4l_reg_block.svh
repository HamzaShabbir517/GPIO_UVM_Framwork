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
