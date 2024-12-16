// Include Defines
`include "axi4l_defines.svh"
`include "gpio_defines.svh"

// Declaration of Package
package gpio_virtual_sequence_lib_pkg;

	// Import UVM Package
	import uvm_pkg::*;
	
	// Include UVM Macro
	`include "uvm_macros.svh"
	
	// Import GPIO Agent Package
	import gpio_agent_pkg::*;
	// Import AXI4 Lite Agent Package
	import axi4l_agent_pkg::*;
	// Import GPIO Environment Package
	import gpio_axi4l_env_pkg::*;
	// Import GPIO Bus Sequence Package
	import gpio_bus_sequence_lib_pkg::*;
	
// Declaration of Virtual Base Sequence Class
class gpio_virtual_sequence_base extends uvm_sequence #(uvm_sequence_item);

	// Register it with factory
	`uvm_object_utils(gpio_virtual_sequence_base)
	
	// New Constructor
	function new(string name = "gpio_virtual_sequence_base");
		super.new(name);
	endfunction 
	
	// Declaration of Envrionment Config
	gpio_axi4l_env_config env_cfg;
	
	// Initiate the Sequencers
	axi4l_sequencer axi4l_sqr_h;
	gpio_sequencer gpio_sqr_h;
	
endclass

// Declaration of Basic Test Virtual Sequence 
class basic_test_vseq extends gpio_virtual_sequence_base;
	
	// Register it with factory
	`uvm_object_utils(basic_test_vseq)
	
	// Declaration of Sequences
	gpio_sequence gpio_seq;
	axi4l_sequence axi4l_seq;
	
	// New Constructor
	function new(string name = "basic_test_vseq");
		super.new(name);
	endfunction
	
	// Body task (it is equivalent to run task of uvm_component)
	task body();
		
		// Create the Sequences
		gpio_seq = gpio_sequence::type_id::create("gpio_seq");
		axi4l_seq = axi4l_sequence::type_id::create("axi4l_seq");
		
		// Start the sequences on to their respective sequencers parallely
		fork
			gpio_seq.start(gpio_sqr_h);
			axi4l_seq.start(axi4l_sqr_h);
		join
			
	endtask 
endclass 

// Declaration of Regster Test Virtual Sequence
class reg_test_vseq extends gpio_virtual_sequence_base;
	
	// Register it with factory
	`uvm_object_utils(reg_test_vseq)
	
	// Declaration of Sequences
	gpio_sequence gpio_seq;
	gpio_bus_write_sequence bus_write_seq;
	
	
	
	// New Constructor
	function new(string name = "reg_test_vseq");
		super.new(name);
	endfunction
	
	// Body task (it is equivalent to run task of uvm_component)
	task body();
		// Create the Sequences
		gpio_seq = gpio_sequence::type_id::create("gpio_seq");
		bus_write_seq = gpio_bus_write_sequence::type_id::create("bus_write_seq");
		bus_write_seq.env_cfg = env_cfg;
		// Start the sequences on to their respective sequencers parallely
		fork
			gpio_seq.start(gpio_sqr_h);
			bus_write_seq.start(m_sequencer);
		join
			
	endtask 
endclass 
endpackage
