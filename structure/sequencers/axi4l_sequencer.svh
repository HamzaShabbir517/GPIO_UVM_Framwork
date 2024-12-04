// Declare AXI4 Lite sequencer class
class axi4l_sequencer #(int data_width = 32, int addr_width = 32) extends uvm_sequencer #(axi4l_sequence_item #(data_width,addr_width));

	// Register it with factory
	`uvm_component_param_utils(axi4l_sequencer #(data_width,addr_width))
	
	// New Constructor
	function new(string name = "axi4l_sequencer", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
endclass
