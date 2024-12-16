// Include Defines
`include "axi4l_defines.svh"

// Declaration of AXI4 Lite Sequence Item
class axi4l_sequence_item #(int data_width = 32, int addr_width = 32) extends uvm_sequence_item;

	// Register it with factory
	`uvm_object_param_utils(axi4l_sequence_item #(`data_width,`addr_width))
	
	// Request Variables
	rand logic [`addr_width-1:0] addr;
	rand bit write;
	rand logic [`data_width-1:0] wdata;
	rand logic [(`data_width/8)-1:0] wstrb;
	
	// Response Vaiables
	logic [`data_width-1:0] rdata;
	logic [1:0] resp;
	
	// Constraints
	// Address is aligned
	constraint addr_aligned { addr[1:0] == 0; }
	
	// Wstrb is not zero when write is enable
	constraint wstrb_non_zero { if (write) wstrb != 0;}
	
	// Address Range Constraint
	// constraint addr_range_c { addr >= 32'h0000_0000; addr <= 32'h0000_0014;}
	
	// New Constructor
	function new(string name = "axi4l_sequence_item");
		super.new(name);
	endfunction
	
	// Convert 2 string function
	virtual function string convert2string();
		return $sformatf("AXI4 Lite: addr=0x%8h \t write=%1b \t wdata=0x%8h \t wstrb=0x%1h \t rdata=0x%8h \t resp=0x%2b", addr, write, wdata, wstrb, rdata, resp);
	endfunction
	
	// Do Copy function
	function void do_copy(uvm_object rhs);
		// Handle of sequence item
		axi4l_sequence_item #(`data_width,`addr_width) RHS;
		
		// Check the compatibility by casting
		if (!$cast(RHS, rhs)) begin
			uvm_report_error("do_copy", "Cast failed, check type compatibility");
			return;
		end
		// Call super do copy function
		super.do_copy(rhs);
		
		// Copy the variables
		addr = RHS.addr;
		write = RHS.write;
		wdata = RHS.wdata;
		wstrb = RHS.wstrb;
		rdata = RHS.rdata;
		resp = RHS.resp;
	endfunction
	
	// Do compare function
	function bit do_compare(uvm_object rhs, uvm_comparer comparer);
		// Handle of sequence item
		axi4l_sequence_item #(`data_width,`addr_width) RHS;
		
		// Check the compatibility by casting
		if (!$cast(RHS, rhs)) begin
			uvm_report_error("do_copy", "Cast failed, check type compatibility");
			return 0;
		end
		
		// Call the super do_compare and also compare the other variables
		return ((super.do_compare(rhs,comparer)) && (addr  == RHS.addr) 
							&& (wdata == RHS.wdata)
							&& (wstrb == RHS.wstrb)
							&& (write == RHS.write)
							&& (rdata == RHS.rdata)
							&& (resp  == RHS.resp));
	endfunction
	
	
	
endclass
