// Declaration of GPIO Package
package gpio_pkg;

	// Importing uvm package
	import uvm_pkg::*;
	
	// Include uvm macros
	`include "uvm_macros.svh"
	
	// Include Environment and Agent Config Objects
	`include "axi4l_agent_config.svh"
	`include "gpio_agent_config.svh"
	`include "environment_config.svh"
	
	// Include Sequence Item
	`include "axi4l_sequence_item.svh"
	`include "gpio_sequence_item.svh"
	
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
	`include "base_test.svh"
	
	
endpackage
