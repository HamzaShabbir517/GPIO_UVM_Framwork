// Include defines
`include "gpio_defines.svh"
 
// Declaration of GPIO Driver
class gpio_driver #(int NUM_PINS = 8) extends uvm_driver #(gpio_sequence_item #(`NUM_PINS));
	
	// Register it with factory
	`uvm_component_param_utils(gpio_driver #(`NUM_PINS))
	
	// Declaration of Virtual Interface
	virtual gpio_interface #(`NUM_PINS) vif;
	
	// New Constructor
	function new(string name = "gpio_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
	
	// Run Task
	task run_phase(uvm_phase phase);
		
		// Declaration of Sequence item
		gpio_sequence_item #(`NUM_PINS) gpio_seq;
		@(negedge vif.rst);
		forever begin
			gpio_seq = gpio_sequence_item #(`NUM_PINS)::type_id::create("gpio_seq",this);
			// Get the next item
			seq_item_port.get_next_item(gpio_seq);
			// Print the data
			`uvm_info("GPIO Driver Run Task %s",gpio_seq.convert2string(),UVM_MEDIUM)
			// Drive the sequence to ports
			drive(gpio_seq);
			// Item is done
			seq_item_port.item_done();
		end 
	endtask
	
	// Drive Task
	task drive(gpio_sequence_item #(`NUM_PINS) gpio_item);
		@(posedge vif.clk);
		if(gpio_item.is_read == 0)
			vif.gpio_in = gpio_item.data_in;
		else begin
		// Nothing to be done
		end
	endtask
endclass
