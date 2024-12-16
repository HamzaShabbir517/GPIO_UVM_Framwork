// Include Macros
`include "uvm_macros.svh"

// Include defines
`include "axi4l_defines.svh"
`include "gpio_defines.svh"

// Declaration of base test classs
class gpio_base_test extends uvm_test;

	// Register it with factory
	`uvm_component_utils(gpio_base_test)
	
	// New Constructor
	function new(string name = "gpio_base_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Declaration of gpio environment
	gpio_axi4l_environment gpio_axi4l_env_h;
	
	// Declaration of config objects
	gpio_axi4l_env_config env_cfg;
	axi4l_agent_config axi4l_cfg;
	gpio_agent_config gpio_cfg;
	
	// Declaration of RAL Model
	gpio_axi4l_reg_block gpio_reg_block;
	
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Create the config objects and configure them
		// Create the environment config object
		env_cfg = gpio_axi4l_env_config::type_id::create("env_cfg");
		
		// Create the Register Model & build it
		gpio_reg_block = gpio_axi4l_reg_block::type_id::create("gpio_reg_block");
		gpio_reg_block.build();
		
		// Pass the handle to config object
		env_cfg.gpio_rm = gpio_reg_block;
		
		// Create the AXI4 Lite config object and configure it
		axi4l_cfg = axi4l_agent_config::type_id::create("axi4l_cfg");
		configure_axi4l(axi4l_cfg);
		env_cfg.axi4l_agent_config_h = axi4l_cfg;
		
		// Create the AXI4 Lite config object and configure it
		gpio_cfg = gpio_agent_config::type_id::create("gpio_cfg");
		configure_gpio(gpio_cfg);
		env_cfg.gpio_agent_config_h = gpio_cfg;
		
		// Configure the rest of the environment config variables
		env_cfg.has_scoreboard = 0;
		env_cfg.has_functional_coverage = 0;
		env_cfg.has_axi4l_agent = 0;
		env_cfg.has_gpio_agent = 0; 
		// Set the Environment Configuration into Data base
		uvm_config_db #(gpio_axi4l_env_config)::set(this,"*","gpio_axi4l_env_config",env_cfg);
		
		// Create Top Environment
		gpio_axi4l_env_h = gpio_axi4l_environment::type_id::create("gpio_env_h",this);
	endfunction
	
	// AXI4 Lite Configuration Function
	virtual function void configure_axi4l(axi4l_agent_config cfg);
		// Agent is active
		cfg.active = UVM_ACTIVE;
		// Functional Coverage
		cfg.has_functional_coverage = 1;
		// Start & End Address
		cfg.start_address = 32'h20000000;
		cfg.range = 32'h18;
		cfg.timeout_cycles = 100;
		// Get the virtual interface from config db
		if(!uvm_config_db #(virtual axi4l_interface #(`addr_width,`data_width))::get(this,"","axi4l_vif",cfg.axi4l_if))
			`uvm_fatal("Base Test",$sformatf("AXI4 Lite Virtual Interface Not Found"));
	endfunction
	
	// GPIO Configuration Function
	virtual function void configure_gpio(gpio_agent_config cfg);
		// Agent is active
		cfg.active = UVM_ACTIVE;
		// Get the virtual interface from config db
		if(!uvm_config_db #(virtual gpio_interface #(`NUM_PINS))::get(this,"","gpio_vif",cfg.gpio_if))
			`uvm_fatal("Base Test",$sformatf("GPIO Virtual Interface Not Found"));
	endfunction
	
	function void init_vseq(gpio_virtual_sequence_base vseq);
		// Declare config object
		gpio_axi4l_env_config cfg;
		// get the config from database
		if (!uvm_config_db #(gpio_axi4l_env_config)::get(this, "*", "gpio_axi4l_env_config", cfg))
			`uvm_fatal("Base Test", "Environment configuration not found");
		
		// If AXI4 Lite Agent in active than only connect it	
		if(cfg.axi4l_agent_config_h.active == UVM_ACTIVE)
			vseq.axi4l_sqr_h = gpio_axi4l_env_h.axi4l_agent_h.axi4l_sqr_h;
		
		// if GPIO Agent is active than only connect it
		if(cfg.gpio_agent_config_h.active == UVM_ACTIVE)
			vseq.gpio_sqr_h = gpio_axi4l_env_h.gpio_agent_h.gpio_sqr_h;
			
		vseq.env_cfg = cfg;
	endfunction
endclass 
