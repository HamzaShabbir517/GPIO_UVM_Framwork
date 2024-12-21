// Declaration of package
package soc_env_pkg;
	
	// Import UVM Package
	import uvm_pkg::*;
	
	// Include UVM Macros
	`include "uvm_macros.svh"
	
	// Import Environment Packages
	import gpio_axi4l_env_pkg::*;
	import gpio_apb_env_pkg::*;
	
	// Import Register Package
	import soc_reg_pkg::*;
	
	// Includes
	`include "soc_env_config.svh"
	`include "soc_environment.svh"
	
endpackage
