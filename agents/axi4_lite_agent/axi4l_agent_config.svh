// Include Defines
`include "axi4l_defines.svh"

// Declaration of AXI4 Lite Configuration Object
class axi4l_agent_config extends uvm_object;
	
	// Declaration of local parameter
	localparam string s_my_config_id = "axi4l_agent_config";
	localparam string s_no_config_id = "no config";
	localparam string s_my_config_type_error_id = "config type error";
	
	// Register it with factory
	`uvm_object_utils(axi4l_agent_config)
	
	// Declaration of Interface
	virtual axi4l_interface #(`addr_width,`data_width) axi4l_if;
	
	// Declaration of Variables
	// Is agent is active or passive
	uvm_active_passive_enum active = UVM_ACTIVE;
	
	// Include the AXI4 Lite functional coverage monitor
	bit has_functional_coverage = 0;
	
	// Include Scoreboard
	bit has_scoreboard = 0;
	
	// Configuration for start address and range
	logic [31:0] start_address;
	logic [31:0] range;
	
	// Timeout for AXI4 Lite Transactions
	int unsigned timeout_cycles = 1000;
	
	// New Constructor
	function new (string name = "axi4l_agent_config");
		super.new(name);
	endfunction
	
	// Get config function
	function axi4l_agent_config get_config (uvm_component c);
		axi4l_agent_config t;
		
		if (!uvm_config_db #(axi4l_agent_config)::get(c, "", s_my_config_id, t))
			`uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))
		
		return t;
	endfunction
endclass
