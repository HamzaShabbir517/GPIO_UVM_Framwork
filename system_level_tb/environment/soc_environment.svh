// Include Defines
`include "axi4l_defines.svh"
`include "apb_defines.svh"

// Declaration of Environment Class
class soc_environment extends uvm_env;
	
	// Register it with factory
	`uvm_component_utils(soc_environment)
	
	// Declaration of Environment Configs
	soc_env_config env_cfg;
	
	// Declaration of Environments
	gpio_axi4l_environment gpio_axi4l_env_h;
	gpio_apb_environment   gpio_apb_env_h;
	
	// New Constructor
	function new(string name = "soc_environment", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Environment Config Object from database
		if(!uvm_config_db #(soc_env_config)::get(this,"*","soc_env_config",env_cfg))
			`uvm_fatal("ENV Build_phase", "unable to get SoC_env_config")
			
		// Create the GPIO AXI4 Lite Environment and also set its Config Object
		uvm_config_db #(gpio_axi4l_env_config)::set(this, "*", "gpio_axi4l_env_config", env_cfg.axi4l_env_cfg);
		gpio_axi4l_env_h = gpio_axi4l_environment::type_id::create("gpio_axi4l_env_h", this);
		
		// Create the GPIO APB Environment and also set its Config Object
		uvm_config_db #(gpio_apb_env_config)::set(this, "*", "gpio_apb_env_config", env_cfg.apb_env_cfg);
		gpio_apb_env_h = gpio_apb_environment::type_id::create("gpio_apb_env_h", this);
	endfunction
	
endclass
