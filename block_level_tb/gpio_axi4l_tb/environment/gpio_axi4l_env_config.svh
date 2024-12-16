// Declaration of GPIO AXI4 Lite Environment Configuration object
class gpio_axi4l_env_config extends uvm_object;
	
	// Declaration of local param
	localparam string s_my_config_id = "gpio_axi4l_env_config";
	localparam string s_no_config_id = "no config";
	localparam string s_my_config_type_error_id = "config type error";
	
	// Register into factory
	`uvm_object_utils(gpio_axi4l_env_config)
	
	// Decalaration of Variables
	bit has_scoreboard = 0;
	bit has_functional_coverage = 0;
	
	// Bit to check which agents are enabled
	bit has_axi4l_agent = 0;
	bit has_gpio_agent = 0;
	
	// Decalaration of agent configs objects
	axi4l_agent_config axi4l_agent_config_h;
	gpio_agent_config  gpio_agent_config_h;
	
	// GPIO with AXI4 Lite Interface Register Model
	gpio_axi4l_reg_block gpio_rm;
	
	// New Constructor
	function new (string name = "gpio_axi4l_env_config");
		super.new(name);
	endfunction
	
	// Get config fucntion
	function gpio_axi4l_env_config get_config(uvm_component c);
		gpio_axi4l_env_config t;
			
		// Get config from data base
		if (!uvm_config_db #(gpio_axi4l_env_config)::get(c,"*",s_my_config_id, t))
			`uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))
			
		return t;
	endfunction
endclass	 
