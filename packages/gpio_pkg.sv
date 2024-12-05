// Declaration of GPIO Package
package gpio_pkg;

	// Importing uvm package
	import uvm_pkg::*;
	
	// Include uvm macros
	`include "uvm_macros.svh"
	
	// RAL Modules
	`include "gpio_regs.svh"
	`include "gpio_reg_block.svh"
	
	// Include Environment and Agent Config Objects
	`include "axi4l_agent_config.svh"
	`include "gpio_agent_config.svh"
	`include "environment_config.svh"
	
	
	// Include Sequence Item
	`include "axi4l_sequence_item.svh"
	`include "gpio_sequence_item.svh"
	
	// RAL Adapter
	`include "axi4l_reg_adapter.svh"
	
	// Structures
	// Sequencers
	`include "axi4l_sequencer.svh"
	`include "gpio_sequencer.svh"
	// Drivers
	`include "axi4l_driver.svh"
	`include "gpio_driver.svh"
	// Monitors
	`include "axi4l_monitor.svh"
	`include "gpio_monitor.svh"
	// Agents
	`include "axi4l_agent.svh"
	`include "gpio_agent.svh"
	
	// Environment
	`include "gpio_environment.svh"
	
	// Tests
	`include "gpio_ral_test.svh"
	`include "base_test.svh"
	
	
endpackage
