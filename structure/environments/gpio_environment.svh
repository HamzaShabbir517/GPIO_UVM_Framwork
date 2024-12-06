// Declaration of UVM Macros
`include "uvm_macros.svh"

// Include Defines
`include "axi4l_defines.svh"

// Declaration of GPIO Environment Class
class gpio_environment extends uvm_env;
	
	// Register it with factory
	`uvm_component_utils(gpio_environment);
	
	// Declaration of Environment Configuration object
	gpio_env_config env_cfg_h;
	
	// Declaration of Agents
	axi4l_agent axi4l_agent_h;
	gpio_agent gpio_agent_h;
	
	// Declaration of RAL Model
	gpio_reg_block gpio_ral_model;
	
	// Declaration of Adapter
	axi4l_reg_adapter axi4l_adapter;
	
	// Declaring the Predictor of RAL
	uvm_reg_predictor #(axi4l_sequence_item #(`data_width,`addr_width)) axi4l2reg_predictor;
	
	// Declaration of TLM Analysis FiFo for AXI4 Lite Agent
	uvm_tlm_analysis_fifo #(axi4l_sequence_item #(`data_width,`addr_width)) fifo;
	
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
		
		// Check if Environment Config have the valid RAL model or not
		if(env_cfg_h.gpio_rm == null) begin
			`uvm_error("GPIO ENV", "No Register Model found in cfg");
		end
		else begin
			// Getting the RAL model from config
			gpio_ral_model = env_cfg_h.gpio_rm;
			// Creating the Predictor
			axi4l2reg_predictor = new("axi4l2reg_predictor", this);
		end
		
		// Build the Analysis FIFO
		fifo = uvm_tlm_analysis_fifo #(axi4l_sequence_item #(`data_width,`addr_width))::type_id::create("fifo", this);
		
	endfunction
	
	// Connect Phase
	function void connect_phase(uvm_phase phase);
		
		// Connecting the AXI4 Lite agent with Anlysis FIFO
		if(env_cfg_h.has_axi4l_agent) begin
			// Connect Write Port
			axi4l_agent_h.axi4l_ap_w.connect(fifo.analysis_export);
			// Connect Read Port
			axi4l_agent_h.axi4l_ap_r.connect(fifo.analysis_export);
		end
		// Build and connect the register model if exists
		if(env_cfg_h.gpio_rm == null) begin
			`uvm_error("GPIO ENV", "No Register Model found in cfg");
		end
		else begin
			axi4l_adapter = axi4l_reg_adapter::type_id::create("axi4l_adapter");
			// Connect the RAL sequencer with agent sequencer
			gpio_ral_model.axi4l_map.set_sequencer(axi4l_agent_h.axi4l_sqr_h, axi4l_adapter);
			// Configure the starting address of Map
			gpio_ral_model.axi4l_map.set_base_addr(env_cfg_h.axi4l_agent_config_h.start_address);
			
			// Connect the predictor map with ral map 
			axi4l2reg_predictor.map = gpio_ral_model.axi4l_map;
			// Connect the predictor adapter with actual adapter
			axi4l2reg_predictor.adapter = axi4l_adapter;
			// Connect the FIFO Analysis port with predictor
			fifo.analysis_export.connect(axi4l2reg_predictor.bus_in);
		end
	endfunction
endclass
