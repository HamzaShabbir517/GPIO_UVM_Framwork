// Include Defines
`include "apb_defines.svh"

// Declaration of APB Package
package apb_agent_pkg;
	
	// Import uvm pkg
	import uvm_pkg::*;
	
	// Include uvm macros
	`include "uvm_macros.svh"
	
	// Include config macro
	`include "config_macro.svh"
	
	// Include Agent Config
	`include "apb_agent_config.svh"
	
	// Include Sequence Item
	`include "apb_sequence_item.svh"
	
	// Include Driver Monitor and Sequencer
	`include "apb_driver.svh"
	`include "apb_monitor.svh"
	typedef uvm_sequencer #(apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE),apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE)) apb_sequencer;
	
	// Include Coverage
	`include "apb_coverage_monitor.svh"
	
	// Include Agent
	`include "apb_agent.svh"
	
	// Include Reg 2 APB adapter for RAL
	`include "reg2apb_adapter.svh"
	
	// Include Utility Sequence
	`include "apb_sequence.svh"
	
endpackage
