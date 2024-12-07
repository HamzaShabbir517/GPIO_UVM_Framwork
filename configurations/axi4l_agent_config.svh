// Include Defines
`include "axi4l_defines.svh"

// Declaration of AXI4 Lite Configuration Object
class axi4l_agent_config extends uvm_object;
	
	// Register it with factory
	`uvm_object_utils(axi4l_agent_config)
	
	// Declaration of Variables
	uvm_active_passive_enum active = UVM_ACTIVE;
	
	
	// Configuration for start address and end address
	logic [31:0] start_address;
	logic [31:0] end_address;
	
	// Timeout for AXI4 Lite Transactions
	int unsigned timeout_cycles = 1000;
	
	// Declaration of Interface
	virtual axi4l_interface #(`addr_width,`data_width) axi4l_if;
	
	// New Constructor
	function new (string name = "axi4l_agent_config");
		super.new(name);
	endfunction
endclass
