// Include defines
`include "gpio_defines.svh"

// Declaration of GPIO Monitor 
class gpio_monitor #(int NUM_PINS = 8) extends uvm_monitor;

	// Register it with factory
	`uvm_component_param_utils(gpio_monitor #(`NUM_PINS))
	
	// Declaration of Virtual Interface
	virtual interface gpio_interface #(`NUM_PINS) vif;
	
	// Declaration of Analysis port
	uvm_analysis_port #(gpio_sequence_item #(`NUM_PINS)) gpio_m_ap;
	
	// New Constructor
	function new(string name = "gpio_monitor", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	// Build Phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		// Build the analysis port
		gpio_m_ap = new("gpio_m_ap", this);
		
	endfunction
	
	// Run task
	task run_phase(uvm_phase phase);
		// Declaration of Sequence item
		gpio_sequence_item #(`NUM_PINS) gpio_seq, gpio_seq_clone;
		gpio_seq = gpio_sequence_item #(`NUM_PINS)::type_id::create("gpio_seq",this);
		@(negedge vif.rst);
		@(posedge vif.clk);
		forever begin
			// Monitor the signals
			@(posedge vif.clk);
			gpio_seq.data_in = vif.gpio_in;
			gpio_seq.data_out = vif.gpio_out & vif.gpio_oe;
			// Create a copy of the transaction object using clone()
			$cast(gpio_seq_clone, gpio_seq.clone()); 
			// Write the sequence into analysis port
			gpio_m_ap.write(gpio_seq_clone);
			// Print the data
			`uvm_info("GPIO Monitor Run Task %s",gpio_seq_clone.convert2string(),UVM_MEDIUM)
		end
	endtask
endclass
