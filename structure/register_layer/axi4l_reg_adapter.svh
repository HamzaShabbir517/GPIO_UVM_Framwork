// Include defines
`include "axi4l_defines.svh"

// Declaration of AXI4 Lite Register Adapter
class axi4l_reg_adapter extends uvm_reg_adapter;
	
	// Register it with factory
	`uvm_object_utils(axi4l_reg_adapter)
	
	// New Constructor
	function new(string name = "axi4l_reg_adapter");
		super.new(name);
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
		axi4l_seq.wdata = rw.data;
		axi4l_seq.wstrb = rw.byte_en;
		
		return axi4l_seq;
	endfunction
	
	// Bus 2 Register Conversion function
	virtual function void bus2reg(uvm_sequence_item bus_item,
ref uvm_reg_bus_op rw);
		// Declare Bus sequence item
		axi4l_sequence_item #(`data_width,`addr_width) axi4l_seq;
		
		// Casting the coming bus item with sequence item
		if (!$cast(axi4l_seq, bus_item))
			`uvm_fatal("CAST_FAIL", "Failed to cast bus to axi4l_sequence_item");
		
		// Now Convert the bus sequence into register
		rw.addr = axi4l_seq.addr;
		rw.data = axi4l_seq.rdata;
		rw.kind = axi4l_seq.write ? UVM_WRITE : UVM_READ;
		rw.status = (axi4l_seq.resp == 2'b00) ? UVM_IS_OK : UVM_NOT_OK;
	endfunction
endclass
