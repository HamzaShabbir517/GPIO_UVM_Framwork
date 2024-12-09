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
	
	// Include Sequences
	`include "gpio_sequence.svh"
	`include "axi4l_sequence.svh"
	`include "ral_base_sequence.svh"
	`include "ral_write_sequence.svh"
	`include "ral_read_sequence.svh"
	`include "virtual_seq_base.svh"
	`include "virtual_seq.svh"
	
	
	// RAL Adapter
	`include "axi4l_reg_adapter.svh"
	
	// Structures
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
	`include "gpio_ral_test.svh"
	`include "gpio_port_test.svh"
	`include "axi4l_test.svh"
	`include "virtual_sequence_test.svh"
	
	
	
endpackage
