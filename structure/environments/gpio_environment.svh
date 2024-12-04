// Declaration of UVM Macros
`include "uvm_macros.svh"

// Declaration of GPIO Environment Class
class gpio_environment extends uvm_env;
	
	// Register it with factory
	`uvm_component_utils(gpio_environment);
	
	// Declaration of Environment Configuration object
	gpio_env_config env_cfg_h;
	
	// Declaration of Agents
	axi4l_agent axi4l_agent_h;
	gpio_agent gpio_agent_h;
	
	// New Constructor
	function new(string name = "gpio_environment", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Environment Config Object from database
		if(!uvm_config_db #(gpio_env_config)::get(this,"*","gpio_env_config",env_cfg_h))
		`uvm_error("ENV Build_phase", "unable to get gpio_env_config");
		
		// If AXI4 Lite Agent is enabled
		if(env_cfg_h.has_axi4l_agent) begin
			// Create the agent
			axi4l_agent_h = axi4l_agent::type_id::create("axi4l_agent_h",this);
			// Set the agent configuration into database 
			uvm_config_db #(axi4l_agent_config)::set(this,"*","axi4l_agent_config",env_cfg_h.axi4l_agent_config_h);
		end
		
		// If GPIO Agent is enabled
		if(env_cfg_h.has_gpio_agent) begin
			// Create the agent
			gpio_agent_h = gpio_agent::type_id::create("gpio_agent_h",this);
			// Set the agent configuration into database 
			uvm_config_db #(gpio_agent_config)::set(this,"*","gpio_agent_config",env_cfg_h.gpio_agent_config_h);
		end
	endfunction
	
	// Connect Phase
	function void connect_phase(uvm_phase phase);
		// Will be added
	endfunction
endclass
