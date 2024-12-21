// Include defines
`include "axi4l_defines.svh"
`include "apb_defines.svh"
`include "gpio_defines.svh"

// Declaration of base test class
class soc_base_test extends uvm_test;
	
	// Register it with factory
	`uvm_component_utils(soc_base_test) 
	
	// New Constructor
	function new(string name = "soc_base_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Declaration of SoC environment
	soc_environment soc_env_h;
	
	// Declaration of Environment Configs
	soc_env_config env_cfg;
	gpio_axi4l_env_config axi4l_env_cfg;
	gpio_apb_env_config   apb_env_cfg;
	
	// Individual Agents Configs
	axi4l_agent_config axi4l_cfg;
	apb_agent_config  apb_cfg;
	gpio_agent_config gpio_cfg;
	
	// Declaration of Register Block
	soc_reg_block soc_register_model;
	
	// Build Function
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Create the main environment config
		env_cfg = soc_env_config::type_id::create("env_cfg");
		
		// Register model
  		// Enable all types of coverage available in the register model
 		uvm_reg::include_coverage("*", UVM_CVR_ALL);
 		
 		// Create the Register Model & build it
		soc_register_model = soc_reg_block::type_id::create("soc_register_model");
		soc_register_model.build();
		
		// Pass the handle to config object
		env_cfg.soc_rm = soc_register_model;
		
		// Sub Environment 1 Configuration
		axi4l_env_cfg = gpio_axi4l_env_config::type_id::create("axi4l_env_cfg");
		axi4l_env_cfg.gpio_rm = soc_register_model.gpio_axi4l_rb;
		
			// AXI4 Lite Agent in Sub Environment
			axi4l_cfg = = axi4l_agent_config::type_id::create("axi4l_cfg");
			configure_axi4l(axi4l_cfg);
			axi4l_env_cfg.axi4l_agent_config_h = axi4l_cfg;
		
			// Create the GPIO config object and configure it
			gpio_cfg = gpio_agent_config::type_id::create("gpio_cfg");
			configure_gpio(gpio_cfg);
			axi4l_env_cfg.gpio_agent_config_h = gpio_cfg;
			
			
			
		env_cfg.axi4l_env_cfg = axi4l_env_cfg;
		
		// Set the Environment Configuration into Data base
		uvm_config_db #(gpio_axi4l_env_config)::set(this,"*","gpio_axi4l_env_config",axi4l_env_cfg);
		
		// Sub Environment 2 Configuration
		apb_env_cfg = gpio_apb_env_config::type_id::create("apb_env_cfg");
		apb_env_cfg.gpio_rm = soc_register_model.gpio_apb_rb;
		
			// APB Agent in Sub Environment
			apb_cfg = = apb_agent_config::type_id::create("apb_cfg");
			configure_apb(apb_cfg);
			apb_env_cfg.apb_agent_config_h = apb_cfg;
		
			// Create the GPIO config object and configure it
			gpio_cfg = gpio_agent_config::type_id::create("gpio_cfg");
			configure_gpio(gpio_cfg);
			apb_env_cfg.gpio_agent_config_h = gpio_cfg;
			
			
			
		env_cfg.apb_env_cfg = apb_env_cfg;
		
		// Set the Environment Configuration into Data base
		uvm_config_db #(gpio_apb_env_config)::set(this,"*","gpio_apb_env_config",apb_env_cfg);
		
		// Set the Main Environment Config into Data Base
		uvm_config_db #(soc_env_config)::set(this,"*","soc_env_config",env_cfg);
		
		// Create Top Environment
		soc_env_h = soc_environment::type_id::create("soc_env_h",this);
	endfunction
	
	// AXI4 Lite Configuration Function
	virtual function void configure_axi4l(axi4l_agent_config cfg);
		// Agent is active
		cfg.active = UVM_PASSIVE;
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
	
	// APB Configuration Function
	virtual function void configure_apb(apb_agent_config cfg);
		// Agent is active
		cfg.active = UVM_PASSIVE;
		// Functional Coverage
		cfg.has_functional_coverage = 1;
		// Start & End Address
		cfg.start_address = 32'h20001000;
		cfg.range = 32'h20;
		cfg.timeout_cycles = 1000;
		// Get the virtual interface from config db
		if(!uvm_config_db #(virtual apb_interface #(`PADDR_SIZE,`PDATA_SIZE))::get(this,"","apb_vif",cfg.apb_if))
			`uvm_fatal("Base Test",$sformatf("APB Virtual Interface Not Found"));
	endfunction
	
	// GPIO Configuration Function
	virtual function void configure_gpio(gpio_agent_config cfg);
		// Agent is active
		cfg.active = UVM_ACTIVE;
		// Get the virtual interface from config db
		if(!uvm_config_db #(virtual gpio_interface #(`NUM_PINS))::get(this,"","gpio_vif",cfg.gpio_if))
			`uvm_fatal("Base Test",$sformatf("GPIO Virtual Interface Not Found"));
	endfunction
	
	// Assign Virtual Sequencers
	function void init_vseq(soc_virtual_sequence_base vseq);
		// Declare config object
		soc_env_config env_cfg;
		
		// get the config from database
		if (!uvm_config_db #(soc_env_config)::get(this, "*", "soc_env_config", env_cfg))
			`uvm_fatal("Base Test", "Environment configuration not found");
		
		// If APB Agent in active than only connect it	
		if(env_cfg.apb_env_cfg.apb_agent_config_h.active == UVM_ACTIVE)
			vseq.apb_sqr_h = soc_env_h.gpio_apb_env_h.apb_agent_h.apb_sqr_h;
			
		// If AXI4 Lite Agent in active than only connect it	
		if(env_cfg.axi4l_env_cfg.axi4l_agent_config_h.active == UVM_ACTIVE)
			vseq.axi4l_sqr_h = soc_env_h.gpio_axi4l_env_h.axi4l_agent_h.axi4l_sqr_h;
		
		
		vseq.gpio_sqr_h_1 = soc_env_h.gpio_apb_env_h.gpio_agent_h.gpio_sqr_h;
		vseq.gpio_sqr_h_2 = soc_env_h.gpio_axi4l_env_h.gpio_agent_h.gpio_sqr_h;
			
		vseq.env_cfg = env_cfg;
	endfunction

endclass
