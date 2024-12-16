// Include defines
`include "apb_defines.svh"

// Declaration of APB Register Adapter
class reg2apb_adapter extends uvm_reg_adapter;
	
	// Register it with factory
	`uvm_object_utils(reg2apb_adapter)
	
	// New Constructor
	function new(string name = "reg2apb_adapter");
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
		apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE) apb_seq;
		// Create the Sequence item
		apb_seq = apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE)::type_id::create("apb_seq");
		
		// Now convert the register sequence into bus sequence
		apb_seq.addr = rw.addr;
		apb_seq.write = (rw.kind == UVM_WRITE);
		apb_seq.data = rw.data;
		apb_seq.wstrb = rw.byte_en;
		
		return apb_seq;
	endfunction
	
	// Bus 2 Register Conversion function
	virtual function void bus2reg(uvm_sequence_item bus_item,
ref uvm_reg_bus_op rw);
		// Declare Bus sequence item
		apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE) apb_seq;
		
		// Casting the coming bus item with sequence item
		if (!$cast(apb_seq, bus_item)) begin
			`uvm_fatal("CAST_FAIL", "Failed to cast bus to apb_sequence_item")
			return;
		end
		
		// Now Convert the bus sequence into register
		rw.addr = apb_seq.addr;
		rw.data = apb_seq.data;
		rw.kind = apb_seq.write ? UVM_WRITE : UVM_READ;
		rw.status = (apb_seq.error == 1'b0) ? UVM_IS_OK : UVM_NOT_OK;
	endfunction
endclass
