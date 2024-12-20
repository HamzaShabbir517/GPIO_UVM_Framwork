// Include Defines
`include "apb_defines.svh"

// Declaration of GPIO Environment Class
class gpio_apb_environment extends uvm_env;
	
	// Register it with factory
	`uvm_component_utils(gpio_apb_environment)
	
	// Declaration of Environment Configuration object
	gpio_apb_env_config env_cfg;
	
	// Declaration of Agents
	apb_agent  apb_agent_h;
	gpio_agent gpio_agent_h;
	
	// Declaration of Adapter
	reg2apb_adapter apb_adapter;
	
	// Declaring the Predictor of RAL
	uvm_reg_predictor #(apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE)) apb2reg_predictor;
	
	// New Constructor
	function new(string name = "gpio_apb_environment", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Get the Environment Config Object from database
		if(!uvm_config_db #(gpio_apb_env_config)::get(this,"*","gpio_apb_env_config",env_cfg))
		`uvm_fatal("ENV Build_phase", "unable to get gpio_apb_env_config")
		
		// If APB Agent is enabled
		if(env_cfg.has_apb_agent) begin
			// Create the agent
			apb_agent_h = apb_agent::type_id::create("apb_agent_h",this);
			// Set the agent configuration into database 
			uvm_config_db #(apb_agent_config)::set(this,"*","apb_agent_config",env_cfg.apb_agent_config_h);
			
			
			// Build the register model predictor and adapter
			// Creating the Predictor
			apb2reg_predictor = new("apb2reg_predictor", this);
			// Creating the Adapter
			apb_adapter = reg2apb_adapter::type_id::create("apb_adapter");
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
		
		// Check if APB is an active agent or not 
		if(env_cfg.apb_agent_config_h.active == UVM_ACTIVE) begin
			// Build and connect the register model if exists
			if(env_cfg.gpio_rm.get_parent() == null) begin
				env_cfg.gpio_rm.gpio_apb_map.set_sequencer(apb_agent_h.apb_sqr_h, apb_adapter);
				
				// Configure the starting address of Map
				env_cfg.gpio_rm.gpio_apb_map.set_base_addr(env_cfg.apb_agent_config_h.start_address);
			end
			
			// Replacing implicit register model prediction with explicit prediction
			// Connect the predictor map with ral map 
			apb2reg_predictor.map = env_cfg.gpio_rm.gpio_apb_map;
			// Connect the predictor adapter with actual adapter
			apb2reg_predictor.adapter = apb_adapter;
			// Disable the register models auto-prediction
			env_cfg.gpio_rm.gpio_apb_map.set_auto_predict(0);
			// Connect the Agent Analysis port with predictor
			apb_agent_h.apb_agent_ap.connect(apb2reg_predictor.bus_in);
		end
	endfunction
endclass
