// Include Defines
`include "axi4l_defines.svh"

// Declaration of AXI4 Lite Package
package axi4l_agent_pkg;

	// Import uvm pkg
	import uvm_pkg::*;
	
	// Include uvm macros
	`include "uvm_macros.svh"
	
	// Include config macro
	`include "config_macro.svh"
	
	// Include Agent Config
	`include "axi4l_agent_config.svh"
	
	// Include Sequence Item
	`include "axi4l_sequence_item.svh"
	
	// Include Driver Monitor and Sequencer
	`include "axi4l_driver.svh"
	`include "axi4l_monitor.svh"
	typedef uvm_sequencer #(axi4l_sequence_item #(`data_width,`addr_width),axi4l_sequence_item #(`data_width,`addr_width)) axi4l_sequencer;
	`include "axi4l_coverage_monitor.svh"
	
	// Include Agent
	`include "axi4l_agent.svh"
	
	// Include Reg 2 AXI4L adapter for RAL
	`include "reg2axi4l_adapter.svh"
	
	// Include Utility Sequence
	`include "axi4l_sequence.svh"
	
endpackage
