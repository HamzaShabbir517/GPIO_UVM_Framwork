// Include defines
`include "axi4l_defines.svh"

// Declaration of AXI4 Lite Register Adapter
class reg2axi4l_adapter extends uvm_reg_adapter;
	
	// Register it with factory
	`uvm_object_utils(reg2axi4l_adapter)
	
	// New Constructor
	function new(string name = "reg2axi4l_adapter");
		super.new(name);
		// Does the protocol the Agent is modeling support byte enables?
		// 0 = NO
		// 1 = YES
		supports_byte_enable = 1;
		
		// Does the Agent's Driver provide separate response sequence items
		// i.e. Does the driver call seq_item_port.put()
		// and do the sequences call get_response()?
		// 0 = NO
		// 1 = YES
		provides_responses = 0;

	endfunction
	
	// Register 2 Bus Conversion function
	virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		// Declare Bus sequence item
		axi4l_sequence_item #(`data_width,`addr_width) axi4l_seq;
		// Create the Sequence item
		axi4l_seq = axi4l_sequence_item #(`data_width,`addr_width)::type_id::create("axi4l_seq");
		
		// Now convert the register sequence into bus sequence
		axi4l_seq.addr = rw.addr;
		axi4l_seq.write = (rw.kind == UVM_WRITE);
		axi4l_seq.data = rw.data;
		axi4l_seq.wstrb = rw.byte_en;
		
		return axi4l_seq;
	endfunction
	
	// Bus 2 Register Conversion function
	virtual function void bus2reg(uvm_sequence_item bus_item,
ref uvm_reg_bus_op rw);
		// Declare Bus sequence item
		axi4l_sequence_item #(`data_width,`addr_width) axi4l_seq;
		
		// Casting the coming bus item with sequence item
		if (!$cast(axi4l_seq, bus_item)) begin
			`uvm_fatal("CAST_FAIL", "Failed to cast bus to axi4l_sequence_item")
			return;
		end
		
		// Now Convert the bus sequence into register
		rw.addr = axi4l_seq.addr;
		rw.data = axi4l_seq.data;
		rw.kind = axi4l_seq.write ? UVM_WRITE : UVM_READ;
		rw.status = (axi4l_seq.resp == 2'b00) ? UVM_IS_OK : UVM_NOT_OK;
	endfunction
endclass
