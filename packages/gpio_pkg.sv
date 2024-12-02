// Declaration of GPIO Package
package gpio_pkg;

	// Importing uvm package
	import uvm_pkg::*;
	
	// Include uvm macros
	`include "uvm_marcos.svh"
	
	// Include Environment and Agent Config Objects
	`include "environment_config.svh"
	`include "gpio_agent_config.svh"
	`include "axi4l_agent_config.svh"
endpackage
