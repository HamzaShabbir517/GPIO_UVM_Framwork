// Inlcude Defines
`include "apb_defines.svh"

// Declaration of APB Agent Config
class apb_agent_config extends uvm_object;

	// Declaration of Local parameter
	localparam string s_my_config_id = "apb_agent_config";
	localparam string s_no_config_id = "no config";
	localparam string s_my_config_type_error_id = "config type error";
	
	// Register it with factory
	`uvm_object_utils(apb_agent_config)
	
	// Declartion of Virtual interface
	virtual interface apb_interface #(`PADDR_SIZE, `PDATA_SIZE) apb_if;
	
	// Declaration of Variables
	// Is agent is active or passive
	uvm_active_passive_enum active = UVM_ACTIVE;
	
	// Include the AXI4 Lite functional coverage monitor
	bit has_functional_coverage = 0;
	
	// Include Scoreboard
	bit has_scoreboard = 0;
	
	// Number of Select Lines
	int no_select_lines = 1;
	
	// Configuration for start address and range
	logic [31:0] start_address;
	logic [31:0] range;
	
	// Timeout 
	int unsigned timeout_cycles = 100;
	
	// New Constructor
	function new (string name = "apb_agent_config");
		super.new(name);
	endfunction
	
	// Get config function
	function apb_agent_config get_config (uvm_component c);
		apb_agent_config t;
		
		if (!uvm_config_db #(apb_agent_config)::get(c, "", s_my_config_id, t))
			`uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", s_my_config_id))
		
		return t;
	endfunction
endclass
