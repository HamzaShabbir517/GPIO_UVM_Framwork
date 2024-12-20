// Declaration of Register Package
package gpio_apb_reg_pkg;
	
	// import uvm package
	import uvm_pkg::*;
	
	// Include macros
	`include "uvm_macros.svh"
	
	// Define Individual Registers
	
	// Declaration of Mode Register 
	class mode_register extends uvm_reg;
		
		// Register it with factory
		`uvm_object_utils(mode_register)
		
		// Declaration of field
		rand uvm_reg_field mode;
		
		// New Constructor
		function new(string name = "mode_register");
			super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
		endfunction
		
		// Build Function
		virtual function void build();
			// Create the reg field
			mode = uvm_reg_field::type_id::create("mode");
			// Configure the register
			// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
			mode.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
		endfunction
		
	endclass
	
	// Declaration of Direction Register
	class direction_register extends uvm_reg;
		
		// Register it with factory
		`uvm_object_utils(direction_register)
		
		// Declaration of field
		rand uvm_reg_field dir;
		
		// New Constructor
		function new(string name = "direction_register");
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
	
	// Declaration of Output Register
	class output_register extends uvm_reg;
		
		// Register it with factory
		`uvm_object_utils(output_register)
		
		// Declaration of field
		rand uvm_reg_field data_o;
		
		// New Constructor
		function new(string name = "output_register");
			super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
		endfunction
		
		// Build Function
		virtual function void build();
			// Create the reg field
			data_o = uvm_reg_field::type_id::create("data_o");
			// Configure the register
			// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
			data_o.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
		endfunction
		
	endclass
	
	// Declaration of Input Register
	class input_register extends uvm_reg;
		
		// Register it with factory
		`uvm_object_utils(input_register)
		
		// Declaration of field
		uvm_reg_field data_i;
		
		// New Constructor
		function new(string name = "input_register");
			super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
		endfunction
		
		// Build Function
		virtual function void build();
			// Create the reg field
			data_i = uvm_reg_field::type_id::create("data_o");
			// Configure the register
			// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
			data_i.configure(this,32,0,"RO",0,32'h00000000,1,0,1);
		endfunction
		
	endclass
	
	// Declaration of Trigger Type Register
	class trigger_type_register extends uvm_reg;
		
		// Register it with factory
		`uvm_object_utils(trigger_type_register)
		
		// Declaration of field
		rand uvm_reg_field trig_t;
		
		// New Constructor
		function new(string name = "trigger_type_register");
			super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
		endfunction
		
		// Build Function
		virtual function void build();
			// Create the reg field
			trig_t = uvm_reg_field::type_id::create("trig_t");
			// Configure the register
			// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
			trig_t.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
		endfunction
		
	endclass
	
	// Declaration of Trigger Low Register
	class trigger_low_register extends uvm_reg;
		
		// Register it with factory
		`uvm_object_utils(trigger_low_register)
		
		// Declaration of field
		rand uvm_reg_field trig_l;
		
		// New Constructor
		function new(string name = "trigger_low_register");
			super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
		endfunction
		
		// Build Function
		virtual function void build();
			// Create the reg field
			trig_l = uvm_reg_field::type_id::create("trig_l");
			// Configure the register
			// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
			trig_l.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
		endfunction
		
	endclass
	
	// Declaration of Trigger High Register
	class trigger_high_register extends uvm_reg;
		
		// Register it with factory
		`uvm_object_utils(trigger_high_register)
		
		// Declaration of field
		rand uvm_reg_field trig_h;
		
		// New Constructor
		function new(string name = "trigger_high_register");
			super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
		endfunction
		
		// Build Function
		virtual function void build();
			// Create the reg field
			trig_h = uvm_reg_field::type_id::create("trig_h");
			// Configure the register
			// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
			trig_h.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
		endfunction
		
	endclass
	
	// Declaration of Trigger Status Register
	class trigger_status_register extends uvm_reg;
		
		// Register it with factory
		`uvm_object_utils(trigger_status_register)
		
		// Declaration of field
		rand uvm_reg_field trig_s;
		
		// New Constructor
		function new(string name = "trigger_status_register");
			super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
		endfunction
		
		// Build Function
		virtual function void build();
			// Create the reg field
			trig_s = uvm_reg_field::type_id::create("trig_s");
			// Configure the register
			// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
			trig_s.configure(this,32,0,"W1C",0,32'h00000000,1,1,1);
		endfunction
		
	endclass
	
	// Declaration of Interrupt Enable Register
	class interrupt_enable_register extends uvm_reg;
		
		// Register it with factory
		`uvm_object_utils(interrupt_enable_register)
		
		// Declaration of field
		rand uvm_reg_field irq_en;
		
		// New Constructor
		function new(string name = "interrupt_enable_register");
			super.new(name,32,UVM_NO_COVERAGE); // 32 is Register Width
		endfunction
		
		// Build Function
		virtual function void build();
			// Create the reg field
			irq_en = uvm_reg_field::type_id::create("irq_en");
			// Configure the register
			// (this, size, lsb, access, volatility, reset, hasReset, isRand, fieldAccess)
			irq_en.configure(this,32,0,"RW",0,32'h00000000,1,1,1);
		endfunction
		
	endclass
	
	
	// Declaration of Register Block
	class gpio_apb_reg_block extends uvm_reg_block;
		
		// Register it with factory
		`uvm_object_utils(gpio_apb_reg_block)
		
		// Declaration of Registers
		rand mode_register      	mode_reg;
		rand direction_register 	dir_reg;
		rand output_register		out_reg;
		rand input_register		in_reg;
		rand trigger_type_register      trig_type_reg;
		rand trigger_low_register       trig_low_reg;
		rand trigger_high_register      trig_high_reg;
		rand trigger_status_register    trig_stat_reg;
		rand interrupt_enable_register  int_reg;
		
		// Declaration of Map
		uvm_reg_map gpio_apb_map;
		
		// New Constructor
		function new(string name = "gpio_apb_map");
			super.new(name, build_coverage(UVM_CVR_ALL));
		endfunction
		
		// Build Function
		virtual function void build();
			// Create the Register, Configure it and than build
			// Backdoor Access  add_hdl_path_slice(Register name, starting bit, size);
			
			// Mode Register
			mode_reg = mode_register::type_id::create("mode_reg");
			mode_reg.configure(this, null, "");
			mode_reg.add_hdl_path_slice("mode_reg", 0, 32);
			mode_reg.build();
			
			// Direction Register
			dir_reg = direction_register::type_id::create("dir_reg");
			dir_reg.configure(this, null, "");
			dir_reg.add_hdl_path_slice("dir_reg", 0, 32);
			dir_reg.build();
			
			// Output Register
			out_reg = output_register::type_id::create("out_reg");
			out_reg.configure(this, null, "");
			out_reg.add_hdl_path_slice("out_reg", 0, 32);
			out_reg.build();
			
			// Input Register
			in_reg = input_register::type_id::create("in_reg");
			in_reg.configure(this, null, "");
			in_reg.add_hdl_path_slice("in_reg", 0, 32);
			in_reg.build();
			
			// Trigger Type Register
			trig_type_reg = trigger_type_register::type_id::create("trig_type_reg");
			trig_type_reg.configure(this, null, "");
			trig_type_reg.add_hdl_path_slice("tr_type_reg", 0, 32);
			trig_type_reg.build();
			
			// Trigger Low Register
			trig_low_reg = trigger_low_register::type_id::create("trig_low_reg");
			trig_low_reg.configure(this, null, "");
			trig_low_reg.add_hdl_path_slice("tr_lvl0_reg", 0, 32);
			trig_low_reg.build();
			
			// Trigger High Register
			trig_high_reg = trigger_high_register::type_id::create("trig_high_reg");
			trig_high_reg.configure(this, null, "");
			trig_high_reg.add_hdl_path_slice("tr_lvl1_reg", 0, 32);
			trig_high_reg.build();
			
			// Trigger Status Register
			trig_stat_reg = trigger_status_register::type_id::create("trig_stat_reg");
			trig_stat_reg.configure(this, null, "");
			trig_stat_reg.add_hdl_path_slice("tr_stat_reg", 0, 32);
			trig_stat_reg.build();
			
			// Interrupt Enable Register
			int_reg = interrupt_enable_register::type_id::create("int_reg");
			int_reg.configure(this, null, "");
			int_reg.add_hdl_path_slice("irq_ena_reg", 0, 32);
			int_reg.build();
			
			// Create the address Map
			// (name, base address, byte address, Endian);
			gpio_apb_map = create_map("gpio_apb_map", 'h0, 4, UVM_LITTLE_ENDIAN);
			default_map = gpio_apb_map;
			
			gpio_apb_map.add_reg(mode_reg, 'h00, "RW");
			gpio_apb_map.add_reg(dir_reg, 'h04, "RW");
			gpio_apb_map.add_reg(out_reg, 'h08, "RW");
			gpio_apb_map.add_reg(in_reg, 'h0C, "RO");
			gpio_apb_map.add_reg(trig_type_reg, 'h10, "RW");
			gpio_apb_map.add_reg(trig_low_reg, 'h14, "RW");
			gpio_apb_map.add_reg(trig_high_reg, 'h18, "RW");
			gpio_apb_map.add_reg(trig_stat_reg, 'h1C, "W1C");
			gpio_apb_map.add_reg(int_reg, 'h20, "RW");
			
			add_hdl_path("hdl_top.apb_dut", "RTL");
			lock_model();
		
		endfunction
	endclass
	
endpackage
