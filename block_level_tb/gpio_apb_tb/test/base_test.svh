// Include Macros
`include "uvm_macros.svh"

// Include defines
`include "apb_defines.svh"
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
	gpio_apb_environment gpio_apb_env_h;
	
	// Declaration of config objects
	gpio_apb_env_config env_cfg;
	apb_agent_config  apb_cfg;
	gpio_agent_config gpio_cfg;
	
	// Declaration of RAL Model
	gpio_apb_reg_block gpio_reg_block;
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Create the config objects and configure them
		// Create the environment config object
		env_cfg = gpio_apb_env_config::type_id::create("env_cfg");
		
		// Register model
		// Enable all types of coverage available in the register model
		uvm_reg::include_coverage("*", UVM_CVR_ALL);
		
		// Create the Register Model & build it
		gpio_reg_block = gpio_apb_reg_block::type_id::create("gpio_reg_block");
		gpio_reg_block.build();
		
		// Pass the handle to config object
		env_cfg.gpio_rm = gpio_reg_block;
		
		// Create the APB config object and configure it
		apb_cfg = apb_agent_config::type_id::create("apb_cfg");
		configure_apb(apb_cfg);
		env_cfg.apb_agent_config_h = apb_cfg;
		
		// Create the AXI4 Lite config object and configure it
		gpio_cfg = gpio_agent_config::type_id::create("gpio_cfg");
		configure_gpio(gpio_cfg);
		env_cfg.gpio_agent_config_h = gpio_cfg;
		
		// Configure the rest of the environment config variables
		env_cfg.has_scoreboard = 0;
		env_cfg.has_functional_coverage = 0;
		env_cfg.has_apb_agent = 0;
		env_cfg.has_gpio_agent = 0; 
		// Set the Environment Configuration into Data base
		uvm_config_db #(gpio_apb_env_config)::set(this,"*","gpio_apb_env_config",env_cfg);
		
		// Create Top Environment
		gpio_apb_env_h = gpio_apb_environment::type_id::create("gpio_apb_env_h",this);
	endfunction
		
	// GPIO Configuration Function
	virtual function void configure_gpio(gpio_agent_config cfg);
		// Agent is active
		cfg.active = UVM_PASSIVE;
		// Get the virtual interface from config db
		if(!uvm_config_db #(virtual gpio_interface #(`NUM_PINS))::get(this,"","gpio_vif",cfg.gpio_if))
			`uvm_fatal("Base Test",$sformatf("GPIO Virtual Interface Not Found"));
	endfunction
	
	// APB Configuration Function
	virtual function void configure_apb(apb_agent_config cfg);
		// Agent is active
		cfg.active = UVM_PASSIVE;
		// Functional Coverage
		cfg.has_functional_coverage = 1;
		// Start & End Address
		cfg.start_address = 32'h30000000;
		cfg.range = 32'h20;
		cfg.timeout_cycles = 1000;
		// Get the virtual interface from config db
		if(!uvm_config_db #(virtual apb_interface #(`PADDR_SIZE,`PDATA_SIZE))::get(this,"","apb_vif",cfg.apb_if))
			`uvm_fatal("Base Test",$sformatf("APB Virtual Interface Not Found"));
	endfunction
	
	function void init_vseq(gpio_virtual_sequence_base vseq);
		// Declare config object
		gpio_apb_env_config cfg;
		// get the config from database
		if (!uvm_config_db #(gpio_apb_env_config)::get(this, "*", "gpio_apb_env_config", cfg))
			`uvm_fatal("Base Test", "Environment configuration not found");
		
		// If APB Agent in active than only connect it	
		if(cfg.apb_agent_config_h.active == UVM_ACTIVE)
			vseq.apb_sqr_h = gpio_apb_env_h.apb_agent_h.apb_sqr_h;
		
		// if GPIO Agent is active than only connect it
		if(cfg.gpio_agent_config_h.active == UVM_ACTIVE)
			vseq.gpio_sqr_h = gpio_apb_env_h.gpio_agent_h.gpio_sqr_h;
			
		vseq.env_cfg = cfg;
	endfunction

endclass
