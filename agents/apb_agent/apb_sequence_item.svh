// Include Defines
`include "apb_defines.svh"

// Declaration of Sequence item
class apb_sequence_item #(int PADDR_SIZE = 32, int PDATA_SIZE = 32) extends uvm_sequence_item;

	// Register it with factory
	`uvm_object_param_utils(apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE))
	
	// Request Variables
	rand logic [`PADDR_SIZE-1:0] addr;
	rand bit write;
	rand logic [`PDATA_SIZE-1:0] data;
	rand logic [(`PDATA_SIZE/8)-1:0] wstrb;
	
	// Response Vaiables
	logic error;

	// Constraints
	// Address is aligned
	constraint addr_aligned { addr[1:0] == 0; }
	
	// Wstrb is not zero when write is enable
	constraint wstrb_non_zero { if (write) wstrb != 0;}
	
	// New Constructor
	function new(string name = "apb_sequence_item");
		super.new(name);
	endfunction
	
	// Convert 2 string function
	virtual function string convert2string();
		return $sformatf("APB: addr=0x%8h \t write=%1b \t data=0x%8h \t wstrb=0x%1h \t error=0x%2b", addr, write, data, wstrb, error);
	endfunction
	
	// Do Copy function
	function void do_copy(uvm_object rhs);
		// Handle of sequence item
		apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE) RHS;
		
		// Check the compatibility by casting
		if (!$cast(RHS, rhs)) begin
			uvm_report_error("do_copy", "Cast failed, check type compatibility");
			return;
		end
		// Call super do copy function
		super.do_copy(rhs);
		
		// Copy the variables
		addr  = RHS.addr;
		write = RHS.write;
		data  = RHS.data;
		wstrb = RHS.wstrb;
		error = RHS.error;
	endfunction
	
	// Do compare function
	function bit do_compare(uvm_object rhs, uvm_comparer comparer);
		// Handle of sequence item
		apb_sequence_item #(`PADDR_SIZE,`PDATA_SIZE) RHS;
		
		// Check the compatibility by casting
		if (!$cast(RHS, rhs)) begin
			uvm_report_error("do_copy", "Cast failed, check type compatibility");
			return 0;
		end
		
		// Call the super do_compare and also compare the other variables
		return ((super.do_compare(rhs,comparer)) && (addr  == RHS.addr) 
							&& (data  == RHS.data)
							&& (wstrb == RHS.wstrb)
							&& (write == RHS.write)
							&& (error == RHS.error));
	endfunction
	
endclass

