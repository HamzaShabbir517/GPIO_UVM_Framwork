// Declaration of Package
package soc_test_lib_pkg;
	
	// Import UVM Package
	import uvm_pkg::*;
	
	// Include UVM Macros
	`include "uvm_macros.svh"
	
	// Import Other Packages
	// Import Bus Agent
	import axi4l_agent_pkg::*;
	// Import Bus Agent
	import apb_agent_pkg::*;
	// Import Design
	import gpio_agent_pkg::*;
	// Import Envrionment 
	import gpio_axi4l_env_pkg::*;
	// Import Envrionment 
	import gpio_apb_env_pkg::*;
	// Import Environment
	import soc_env_pkg::*;
	// Import Register Model
	import soc_reg_pkg::*;
	// Import Bus Sequence 
	import soc_bus_sequence_lib_pkg::*;
	// Import Virtual Sequence
	import soc_virtual_sequence_lib_pkg::*;
	
	// Includes
	`include "soc_base_test.svh"
	`include "gpio_port_test.svh"
	
endpackage
