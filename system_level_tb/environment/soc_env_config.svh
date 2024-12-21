// Declaration of SoC Environment Config
class soc_env_config extends uvm_object;
	
	// Declaration of local params
	localparam string s_my_config_id = "soc_env_config";
	localparam string s_no_config_id = "no config";
	localparam string s_my_config_type_error_id = "config type error";
	
	// Register it with factory
	`uvm_object_utils(soc_env_config)
	
	// Declaration of two environment configs
	gpio_axi4l_env_config axi4l_env_cfg;
	gpio_apb_env_config   apb_env_cfg;
	
	// Declaration of Register Map
	soc_reg_block soc_rm;
	
	// New Constructor
	function new (string name = "soc_env_config");
		super.new(name);
	endfunction
	
	// Get config fucntion
	function soc_env_config get_config(uvm_component c);
		soc_env_config t;
			
		// Get config from data base
		if (!uvm_config_db #(soc_env_config)::get(c,"*",s_my_config_id, t))
			`uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))
			
		return t;
	endfunction
	
endclass
