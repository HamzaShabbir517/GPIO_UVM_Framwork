// Include Defines
`include "axi4l_defines.svh"

// Declaration of GPIO Environment Class
class gpio_axi4l_environment extends uvm_env;
	
	// Register it with factory
	`uvm_component_utils(gpio_axi4l_environment)
	
	// Declaration of Environment Configuration object
	gpio_axi4l_env_config env_cfg;
	
	// Declaration of Agents
	axi4l_agent axi4l_agent_h;
	gpio_agent gpio_agent_h;
	
	// Declaration of Adapter
	reg2axi4l_adapter axi4l_adapter;
	
	// Declaring the Predictor of RAL
	uvm_reg_predictor #(axi4l_sequence_item #(`data_width,`addr_width)) axi4l2reg_predictor;
	
	
	// New Constructor
	function new(string name = "gpio_axi4l_environment", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Environment Config Object from database
		if(!uvm_config_db #(gpio_axi4l_env_config)::get(this,"*","gpio_axi4l_env_config",env_cfg))
		`uvm_fatal("ENV Build_phase", "unable to get gpio_env_config")
		
		// If AXI4 Lite Agent is enabled
		if(env_cfg.has_axi4l_agent) begin
			// Create the agent
			axi4l_agent_h = axi4l_agent::type_id::create("axi4l_agent_h",this);
			// Set the agent configuration into database 
			uvm_config_db #(axi4l_agent_config)::set(this,"*","axi4l_agent_config",env_cfg.axi4l_agent_config_h);
			
			
			// Build the register model predictor and adapter
			// Creating the Predictor
			axi4l2reg_predictor = new("axi4l2reg_predictor", this);
			// Creating the Adapter
			axi4l_adapter = reg2axi4l_adapter::type_id::create("axi4l_adapter");
		end
		
		// If GPIO Agent is enabled
		if(env_cfg.has_gpio_agent) begin
			// Create the agent
			gpio_agent_h = gpio_agent::type_id::create("gpio_agent_h",this);
			// Set the agent configuration into database 
			uvm_config_db #(gpio_agent_config)::set(this,"*","gpio_agent_config",env_cfg.gpio_agent_config_h);
		end
		
	endfunction
	
	// Connect Phase
	function void connect_phase(uvm_phase phase);
		
		// Check if AXI4 Lite is an active agent or not 
		if(env_cfg.axi4l_agent_config_h.active == UVM_ACTIVE) begin
			// Build and connect the register model if exists
			if(env_cfg.gpio_rm.get_parent() == null) begin
				env_cfg.gpio_rm.gpio_axi4l_map.set_sequencer(axi4l_agent_h.axi4l_sqr_h, axi4l_adapter);
				
				// Configure the starting address of Map
					env_cfg.gpio_rm.gpio_axi4l_map.set_base_addr(env_cfg.axi4l_agent_config_h.start_address);
			end
		end
			
			// Replacing implicit register model prediction with explicit prediction
			// Connect the predictor map with ral map 
			axi4l2reg_predictor.map = env_cfg.gpio_rm.gpio_axi4l_map;
			// Connect the predictor adapter with actual adapter
			axi4l2reg_predictor.adapter = axi4l_adapter;
			// Disable the register models auto-prediction
			env_cfg.gpio_rm.gpio_axi4l_map.set_auto_predict(0);
			// Connect the Agent Analysis port with predictor
			axi4l_agent_h.axi4l_agent_ap.connect(axi4l2reg_predictor.bus_in);
	endfunction
endclass
