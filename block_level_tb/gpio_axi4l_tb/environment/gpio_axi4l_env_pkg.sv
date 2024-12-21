// Declaration of Package
package gpio_axi4l_env_pkg;

	// Import UVM Package
	import uvm_pkg::*;
	
	// Include UVM Macros
	`include "uvm_macros.svh"
	
	// Include other packages
	import axi4l_agent_pkg::*;
	import gpio_agent_pkg::*;
	
	// Import Register Package
	import gpio_axi4l_reg_pkg::*;
	
	// Include GPIO Environment Config
	`include "gpio_axi4l_env_config.svh"
	
	// Include GPIO Environment
	`include "gpio_axi4l_environment.svh"
	
endpackage
