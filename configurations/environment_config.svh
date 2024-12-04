// Declaration of Environment Configuration object
class gpio_env_config extends uvm_object;
	
	// Register into factory
	`uvm_object_utils(gpio_env_config)
	
	// Decalaration of Variables
	bit has_scoreboard = 0;
	bit has_functional_coverage = 0;
	
	// Bit to check which agents are enabled
	bit has_axi4l_agent = 0;
	bit has_gpio_agent = 0;
	
	// Decalaration of agent configs objects
	axi4l_agent_config axi4l_agent_config_h;
	gpio_agent_config  gpio_agent_config_h;
	
	// GPIO Register Model
	// gpio_ral_model gpio_rm;
	
	// New Constructor
	function new (string name = "gpio_env_config");
		super.new(name);
	endfunction
endclass	 
