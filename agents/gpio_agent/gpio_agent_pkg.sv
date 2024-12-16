// Include Defines
`include "gpio_defines.svh"

// Declaration of GPIO Agent Package
package gpio_agent_pkg;
	
	// Importing UVM Package
	import uvm_pkg::*;
	
	// Inlcude uvm macros
	`include "uvm_macros.svh"
	
	// Inlcude config macro
	`include "config_macro.svh"
	
	// Include Agent Config
	`include "gpio_agent_config.svh"
	
	// Include Sequence Item
	`include "gpio_sequence_item.svh"
	
	// Include Driver Monitor and Sequencer
	`include "gpio_driver.svh"
	`include "gpio_monitor.svh"
	typedef uvm_sequencer #(gpio_sequence_item #(`NUM_PINS), gpio_sequence_item #(`NUM_PINS)) gpio_sequencer;
	
	// Include Agent
	`include "gpio_agent.svh"
	
	// Include Utility Sequence
	`include "gpio_sequence.svh"
	
endpackage
